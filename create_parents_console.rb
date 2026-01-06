# Console command to create parent accounts for Noe Brennan
# Run this in Rails console: rails c
# Then paste the code below

kid_email = 'noe.brennan@edubga.com'
kid = User.find_by(email: kid_email.strip.downcase)

if kid.nil?
  puts "❌ Kid with email #{kid_email} not found."
  exit
end

if kid.deactivate?
  puts "❌ Kid with email #{kid_email} is deactivated, skipping parent creation."
  exit
end

# Find LCs with less than 3 hubs linked to the kid's hub (only non-deactivated LCs)
lcs = kid.users_hubs.find_by(main: true)&.hub&.users&.where(role: 'lc', deactivate: false)&.select { |lc| lc.hubs.count < 3 } || []

# Parent 1: Renee Brennan
parent1_name = 'Renee Brennan'
parent1_email = 'frauhartmann@gmail.com'
parent1_password = SecureRandom.hex(8)

parent1 = User.find_or_initialize_by(email: parent1_email.strip.downcase)

if parent1.new_record?
  parent1.assign_attributes(
    full_name: parent1_name,
    password: parent1_password,
    password_confirmation: parent1_password,
    confirmed_at: Time.now,
    role: 'Parent',
    kids: [kid.id]
  )

  # Temporarily skip email domain validation
  parent1.define_singleton_method(:email_domain_check) { true }

  if parent1.save
    puts "✅ Parent account for #{parent1_email} created successfully."
    UserMailer.welcome_parent(parent1, parent1_password, lcs).deliver_now
    puts "   Password: #{parent1_password}"
  else
    puts "❌ Failed to save parent account for #{parent1_email}: #{parent1.errors.full_messages.join(', ')}"
  end
else
  # Update existing parent
  parent1.kids << kid.id if kid && !parent1.kids.include?(kid.id)
  if parent1.save
    kid_emails = parent1.kids.map { |kid_id| User.find(kid_id).email }
    puts "✅ Parent account for #{parent1_email} updated. Kids linked: #{kid_emails.join(', ')}"
  else
    puts "❌ Failed to update parent account for #{parent1_email}: #{parent1.errors.full_messages.join(', ')}"
  end
end

# Parent 2: Sage Brennan
parent2_name = 'Sage Brennan'
parent2_email = 'sagebrennan@gmail.com'
parent2_password = SecureRandom.hex(8)

parent2 = User.find_or_initialize_by(email: parent2_email.strip.downcase)

if parent2.new_record?
  parent2.assign_attributes(
    full_name: parent2_name,
    password: parent2_password,
    password_confirmation: parent2_password,
    confirmed_at: Time.now,
    role: 'Parent',
    kids: [kid.id]
  )

  # Temporarily skip email domain validation
  parent2.define_singleton_method(:email_domain_check) { true }

  if parent2.save
    puts "✅ Parent account for #{parent2_email} created successfully."
    UserMailer.welcome_parent(parent2, parent2_password, lcs).deliver_now
    puts "   Password: #{parent2_password}"
  else
    puts "❌ Failed to save parent account for #{parent2_email}: #{parent2.errors.full_messages.join(', ')}"
  end
else
  # Update existing parent
  parent2.kids << kid.id if kid && !parent2.kids.include?(kid.id)
  if parent2.save
    kid_emails = parent2.kids.map { |kid_id| User.find(kid_id).email }
    puts "✅ Parent account for #{parent2_email} updated. Kids linked: #{kid_emails.join(', ')}"
  else
    puts "❌ Failed to update parent account for #{parent2_email}: #{parent2.errors.full_messages.join(', ')}"
  end
end

puts "\n✅ Done!"
