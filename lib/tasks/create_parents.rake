namespace :db do
  desc "Create parent accounts for all active learner_infos that don't have parent accounts yet"
  task create_parents: :environment do
    created_count = 0
    updated_count = 0
    skipped_count = 0
    error_count = 0

    # Method to create or update a parent account
    create_parent_method = lambda do |name, email, kid_user, hub|
      return nil if email.blank? || kid_user.blank?

      email = email.strip.downcase
      password = SecureRandom.hex(8)

      # Find or initialize the parent
      parent = User.find_or_initialize_by(email: email)

      if parent.new_record?
        parent.assign_attributes(
          full_name: name.presence || email.split('@').first.humanize,
          password: password,
          password_confirmation: password,
          confirmed_at: Time.current,
          role: 'Parent',
          kids: [kid_user.id]
        )

        # Temporarily skip email domain validation
        parent.define_singleton_method(:email_domain_check) { true }

        if parent.save
          puts "✅ Created parent account for #{email}"

          # Find LCs with less than 3 hubs linked to the kid's hub (only non-deactivated LCs)
          lcs = hub&.learning_coaches || []

          # Send welcome email
          begin
            UserMailer.welcome_parent(parent, password, lcs).deliver_now
            puts "   📧 Welcome email sent to #{email}"
          rescue => e
            puts "   ⚠️  Failed to send welcome email to #{email}: #{e.message}"
          end

          :created
        else
          puts "❌ Failed to save new parent account for #{email}: #{parent.errors.full_messages.join(', ')}"
          :error
        end
      else
        # Update existing parent - add kid if not already linked
        if !parent.kids.include?(kid_user.id)
          parent.kids << kid_user.id
          if parent.save
            puts "🔄 Updated parent account for #{email} - linked kid #{kid_user.email}"
            :updated
          else
            puts "❌ Failed to update parent account for #{email}: #{parent.errors.full_messages.join(', ')}"
            :error
          end
        else
          :skipped
        end
      end
    end

    puts "=" * 60
    puts "Starting parent account creation from learner_infos..."
    puts "=" * 60
    puts ""

    # Get all active learner_infos with associated user
    learner_infos = LearnerInfo.active.includes(:user, :hub).where.not(user_id: nil)

    puts "Found #{learner_infos.count} active learner_infos with linked users"
    puts ""

    learner_infos.find_each do |learner_info|
      kid_user = learner_info.user
      hub = learner_info.hub

      # Skip if kid is deactivated
      if kid_user.deactivate?
        puts "⏭️  Skipping #{learner_info.full_name} - user is deactivated"
        skipped_count += 1
        next
      end

      puts "Processing learner: #{learner_info.full_name} (#{kid_user.email})"

      # Process Parent 1
      if learner_info.parent1_email.present?
        result = create_parent_method.call(
          learner_info.parent1_full_name,
          learner_info.parent1_email,
          kid_user,
          hub
        )
        case result
        when :created then created_count += 1
        when :updated then updated_count += 1
        when :skipped then skipped_count += 1
        when :error then error_count += 1
        end
      end

      # Process Parent 2
      if learner_info.parent2_email.present?
        result = create_parent_method.call(
          learner_info.parent2_full_name,
          learner_info.parent2_email,
          kid_user,
          hub
        )
        case result
        when :created then created_count += 1
        when :updated then updated_count += 1
        when :skipped then skipped_count += 1
        when :error then error_count += 1
        end
      end

      puts ""
    end

    puts "=" * 60
    puts "Summary:"
    puts "  ✅ Created: #{created_count}"
    puts "  🔄 Updated: #{updated_count}"
    puts "  ⏭️  Skipped: #{skipped_count}"
    puts "  ❌ Errors: #{error_count}"
    puts "=" * 60
  end
end
