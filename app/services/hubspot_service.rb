class HubspotService
  HUBSPOT_ACCESS_TOKEN = ENV['HUBSPOT_ACCESS_TOKEN']
  FORM_GUIDS = [
    '472b7df8-5290-4908-8408-1dcee6e15512',
    '16f15775-fbb4-413d-84e1-3eb24f405d64'
  ]

  def self.fetch_new_submissions
    headers = {
      'Authorization' => "Bearer #{HUBSPOT_ACCESS_TOKEN}",
      'Content-Type'  => 'application/json'
    }

    overall_success = true

    FORM_GUIDS.each do |guid|
      api_url = "https://api.hubapi.com/form-integrations/v1/submissions/forms/#{guid}"

      response = HTTParty.get(api_url, query: { limit: 50 }, headers: headers)

      if response.success?
        data = JSON.parse(response.body)
        data['results'].each { |submission| process_submission(submission) }
        Rails.logger.info "Successfully processed #{data['results'].count} new submissions from form #{guid}."
      else
        Rails.logger.error "HubSpot API Error for form #{guid}: #{response.code} - #{response.body}"
        overall_success = false
      end
    end

    overall_success
  end

  def self.process_submission(submission_data)
    fields = submission_data['values'].map { |v| [v['name'].to_sym, v['value']] }.to_h
    email = fields[:learner_s_personal_email_address]
    conversion_id = submission_data['conversionId']

    Rails.logger.info("All submission fields: #{fields.inspect}")
    Rails.logger.info("Processing submission for email: #{email} (conversionId: #{conversion_id}) at #{Time.zone.at(submission_data['submittedAt']/1000.0)}")

    if conversion_id.present?
      existing = LearnerInfo.find_by(hubspot_conversion_id: conversion_id)

      if existing
        Rails.logger.warn("Skipping submission #{conversion_id}: Matching LearnerInfo (ID: #{existing.id}) already exists.")
        return
      end
    else
      Rails.logger.warn("Warning: Submission for email #{email} has no conversionId. Proceeding with creation.")
    end

    learner_info = create_learner_info(fields, conversion_id)
    unless learner_info
      Rails.logger.error("Failed to create LearnerInfo for submission #{conversion_id} with email #{email}")
      return
    end

    begin
      associate_hub(learner_info, fields)
    rescue => e
      Rails.logger.error("Error associating hub for LearnerInfo ID=#{learner_info.id}: #{e.message}")
    end

    # Set status based on hub capacity after association
    if learner_info.hub_id.present?
      hub = learner_info.hub

      if %w[Online Remote\ 1 Remote\ 2 Remote\ 3 Undetermined].include?(hub.name)
        # These hubs always have capacity
        learner_info.update!(status: 'In progress conditional')
        Rails.logger.info("Set status to 'In progress conditional' for LearnerInfo ID: #{learner_info.id} (Online hub always has capacity)")
      else
        active_count = LearnerInfo.where(hub_id: hub.id)
                                  .where.not(id: learner_info.id)
                                  .where.not(status: ['Inactive', 'Graduated'])
                                  .count

        if active_count < hub.capacity
          learner_info.update!(status: 'In progress conditional')
          Rails.logger.info("Set status to 'In progress conditional' for LearnerInfo ID: #{learner_info.id} (hub has capacity)")
        else
          learner_info.update!(status: 'Waitlist')
          Rails.logger.info("Set status to 'Waitlist' for LearnerInfo ID: #{learner_info.id} (hub at capacity)")
        end
      end
    else
      Rails.logger.warn("No hub associated for LearnerInfo ID: #{learner_info.id} - Status remains unset")
    end

    begin
      create_learner_finances(learner_info, fields)
    rescue => e
      Rails.logger.error("Error creating finances for LearnerInfo ID=#{learner_info.id}: #{e.message}")
    end

    begin
      attach_files_for_learner(learner_info, fields)
    rescue => e
      Rails.logger.error("Error attaching files for LearnerInfo ID=#{learner_info.id}: #{e.message}")
    end
  end

  def self.fetch_contact_remote_region(email)
    return nil if email.blank?

    search_endpoint = "https://api.hubapi.com/crm/v3/objects/contacts/search"
    headers = {
      'Authorization' => "Bearer #{HUBSPOT_ACCESS_TOKEN}",
      'Content-Type' => 'application/json'
    }

    body = {
      filterGroups: [{
        filters: [{
          propertyName: 'email',
          operator: 'EQ',
          value: email
        }]
      }],
      properties: ['remote_region'],
      limit: 1
    }.to_json

    response = HTTParty.post(search_endpoint, body: body, headers: headers)

    if response.success?
      data = JSON.parse(response.body)
      if data['total'] > 0
        data['results'][0]['properties']['remote_region']
      else
        Rails.logger.warn "No contact found in HubSpot for email: #{email}"
        nil
      end
    else
      Rails.logger.error "HubSpot Contact Search API Error: #{response.code} - #{response.body}"
      nil
    end
  end

  def self.associate_hub(learner_info, fields)
    hubspot_key = fields[:hub_interest_portugal]
    school_name = fields[:school_s_name]

    if hubspot_key.present?
      hub = Hub.find_by(hubspot_key: hubspot_key)
      if hub
        learner_info.update!(hub_id: hub.id)
        Rails.logger.info("Associated hub '#{hub.name}' (ID: #{hub.id}) with LearnerInfo ID: #{learner_info.id}")
      else
        Rails.logger.warn("No hub found for hubspot_key: #{hubspot_key} - LearnerInfo ID: #{learner_info.id} remains without hub association.")
      end
      return
    elsif school_name.present?
      # Match exact school_name value to hub.name (no parsing/stripping)
      hub = Hub.find_by(name: school_name)
      if hub
        learner_info.update!(hub_id: hub.id)
        Rails.logger.info("Associated hub '#{hub.name}' (ID: #{hub.id}) with LearnerInfo ID: #{learner_info.id} from school_s_name")
      else
        Rails.logger.warn("No hub found for exact school_name: #{school_name} - LearnerInfo ID: #{learner_info.id} remains without hub association.")
      end
      return
    end

    # Fallback for online/remote learners (unchanged)
    form_email = fields[:email]
    remote_region = fetch_contact_remote_region(form_email)
    region_display = remote_region || '(not defined)'
    Rails.logger.info("ONLINE LEARNER ASSOCIATION: #{region_display} for learner ID #{learner_info.id} (email: #{form_email})")

    target_hub_name =
      if remote_region.blank?
        'Undetermined'
      else
        m = remote_region.to_s.strip.match(/region\s*([1-3])\b/i)
        "Remote #{m[1].to_i}" if m
      end
    target_hub_name ||= 'Undetermined'
    target_hub = Hub.find_by(name: target_hub_name)

    if target_hub
      learner_info.update!(hub_id: target_hub.id)
      Rails.logger.info("Associated '#{target_hub_name}' hub (ID: #{target_hub.id}) with LearnerInfo ID: #{learner_info.id}. (remote_region: #{region_display})")
    else
      Rails.logger.warn("No '#{target_hub_name}' hub found - LearnerInfo ID: #{learner_info.id} remains without hub association. (remote_region: #{region_display})")
    end
  end

  def self.create_learner_info(fields, conversion_id = nil)
    learner_info_mapping = {
      :learning_model                    => :programme,
      :curriculum_option__2_             => :curriculum_course_option,
      :curriculum_option_pwb             => :curriculum_course_option,
      :current_school_grade_year         => :previous_school_grade_year,
      :previous_school_status            => :previous_school_status,
      :previous_school_s_name            => :previous_school_name,
      :school_s_name                     => :previous_school_name,
      :previous_school_s_email           => :previous_school_email,
      :studentname                       => :full_name,
      :learner_s_personal_email_address  => :personal_email,
      :learner_s_phone_number__2_        => :phone_number,
      :learner_s_date_of_birth           => :birthdate,
      :learner_s_nationality             => :nationality,
      :learner_s_id_document__name_and_type_ => :id_information,
      :invoicing_data                    => :fiscal_number,
      :english_fluency__official_        => :english_proficiency,
      :gender__2_                        => :gender,
      :parent_1____name                  => :parent1_full_name,
      :parent_1____email                 => :parent1_email,
      :parent_1___phone_number           => :parent1_phone_number,
      :parent_1___identification_document__number_and_type_ => :parent1_id_information,
      :parent_2___full_name              => :parent2_full_name,
      :parent_2___email                  => :parent2_email,
      :parent_2___phone_number__2_       => :parent2_phone_number,
      :parent_2___identification_document__number_and_type_ => :parent2_id_information,
      :emergency_protocol                => :emergency_protocol_choice,
    }

    attrs = {}
    learner_info_mapping.each do |hub_key, model_col|
      next unless fields[hub_key].present?
      val = fields[hub_key]

      if [:personal_email, :previous_school_email, :parent1_email, :parent2_email].include?(model_col)
        val = normalize_email(val)
        next unless val.present?
      end

      if model_col == :birthdate
        timestamp_seconds = val.to_i / 1000
        val = Time.at(timestamp_seconds).to_date
        val = (Date.parse(val) rescue val)
      end

      if model_col == :english_proficiency
        val = (val != "None")
      end

      attrs[model_col] = val
    end

    # Capture raw programme value for special handling
    raw_programme = fields[:learning_model]

    # Special handling for UP Programme (using raw value)
    if raw_programme.in?(["UP Programme (Higher Education)", "UP Programme (Online: Higher Education)"]) && fields[:level].present?
      attrs[:curriculum_course_option] = fields[:level]
    end

    # Image consent boolean
    consent_string = "I consent to the above mentioned conditions"
    attrs[:use_of_image_authorisation] = (fields[:use_of_image_authorization].to_s == consent_string)

    # Grade calculation if present
    curriculum = attrs[:curriculum_course_option]
    raw_grade  = fields[:grade_year]
    if curriculum.present? && raw_grade.present?
      calculated_grade = LearnerInfo.calculate_grade_from_hubspot(raw_grade, curriculum)
      attrs[:grade_year] = calculated_grade if calculated_grade.present?
    end

    # Address combination
    address_keys = [:address, :city, :zip, :country]
    if address_keys.any? { |k| fields[k].present? }
      attrs[:home_address] = address_keys.map { |k| fields[k] }.compact.join(', ')
    end

    # Map programme to Online or Hybrid (after special handling), default to 'Hybrid' if not present
    if raw_programme.present?
      downcased = raw_programme.downcase
      if downcased.include?('remote') || downcased.include?('online')
        attrs[:programme] = 'Online'
      else
        attrs[:programme] = 'Hybrid'
      end
    else
      attrs[:programme] = 'Hybrid'
    end

    # Store conversion_id if provided
    attrs[:hubspot_conversion_id] = conversion_id if conversion_id.present?

    learner_info = LearnerInfo.new(attrs)
    learner_info.skip_email_validation = true

    if learner_info.save
      Rails.logger.info("Successfully created NEW LearnerInfo for #{learner_info.full_name} (ID: #{learner_info.id}) with conversionId #{conversion_id}")
      learner_info
    else
      Rails.logger.error("FATAL ERROR: Failed to create LearnerInfo for #{attrs[:full_name]}: #{learner_info.errors.full_messages.join(', ')}")
      nil
    end
  end

  def self.create_learner_finances(learner_info, fields)
    payment_plan = fields[:payment_plan]
    financial_responsibility = fields[:financial_responsibility]

    finance_attrs = {
      payment_plan: payment_plan,
      financial_responsibility: financial_responsibility,
      discount_mf: 0,
      scholarship: 0,
      discount_af: 0,
      discount_rf: 0
    }

    year = Date.today.year

    # Fetch pricing tier using the matcher if hub is associated
    if learner_info.hub
      tier = PricingTierMatcher.for_learner(
        learner_info,
        learner_info.curriculum_course_option,
        learner_info.hub,
        year
      )

      if tier
        finance_attrs[:monthly_fee] = tier.monthly_fee
        finance_attrs[:admission_fee] = tier.admission_fee
        finance_attrs[:renewal_fee] = tier.renewal_fee
        Rails.logger.info("Applied pricing tier for LearnerInfo ID: #{learner_info.id} - Tier ID: #{tier.id} (Year: #{year})")
      else
        Rails.logger.warn("No matching pricing tier found for LearnerInfo ID: #{learner_info.id} (Hub: #{learner_info.hub.name}, Curriculum: #{learner_info.curriculum_course_option}, Year: #{year})")
      end
    else
      Rails.logger.warn("No hub associated for LearnerInfo ID: #{learner_info.id} - Skipping pricing tier lookup")
    end

    finance_record = learner_info.build_learner_finance(finance_attrs)

    if finance_record.save
      Rails.logger.info("Successfully created LearnerFinances for LearnerInfo ID: #{learner_info.id}")
    else
      Rails.logger.error("Failed to save LearnerFinances for #{learner_info.full_name}: #{finance_record.errors.full_messages.join(', ')}")
    end

    finance_record
  end

  def self.attach_files_for_learner(learner_info, fields)
    file_field_mapping = {
      previous_school_transcripts:   'last_term_report',
      current_academic_qualifications__up_: 'last_term_report',
      last_term_report:              'last_term_report',
      special_education_form:        'special_needs',
      learner_s_id_document_picture: 'learner_id',
      letter_of_interest:            'letter_of_interest',
      picture:                       'picture',
      medical_form:                  'medical_form',
      parent_1_id_document_picture:  'parent_id',
      parent_2_id_document_photo:    'parent_id',
      parent_1_id_file:              'parent_id',
      parent_2___id_file:            'parent_id'
    }

    file_field_mapping.each do |hub_key, doc_type|
      next unless fields[hub_key].present?

      raw = fields[hub_key]
      values = raw.is_a?(Array) ? raw : [raw]

      values.each_with_index do |value, idx|
        begin
          if value.blank?
            Rails.logger.warn("Empty value for file field #{hub_key}, skipping.")
            next
          end

          unless value.is_a?(String)
            Rails.logger.error("Unexpected value type for #{hub_key}: #{value.class}. Expected signed-url string.")
            next
          end

          file_id = extract_file_id_from_url(value)
          unless file_id
            Rails.logger.error("Could not extract file_id from HubSpot value for #{hub_key}: #{value.inspect}")
            next
          end

          download_url = get_download_url_for_file(file_id)
          unless download_url
            Rails.logger.error("Could not obtain download URL for file_id #{file_id} (field #{hub_key})")
            next
          end

          description = (values.size > 1) ? "#{hub_key.to_s.humanize} (#{idx + 1})" : hub_key.to_s.humanize

          download_and_attach(learner_info, download_url, doc_type, description)
          Rails.logger.info("Attached #{doc_type} for LearnerInfo ID=#{learner_info.id} from field #{hub_key}")

        rescue => e
          Rails.logger.error("Error processing file field #{hub_key} for learner #{learner_info.id}: #{e.message}\n#{e.backtrace.first(5).join("\n")}")
        end
      end
    end
  end

  def self.extract_file_id_from_url(url)
    uri = URI.parse(url)
    if uri.path =~ %r{\/signed-url-redirect\/([^\/\?]+)}
      return $1
    end
    nil
  end

  def self.get_download_url_for_file(file_id)
    endpoint = "https://api.hubapi.com/files/v3/files/#{file_id}/signed-url"
    headers = { "Authorization" => "Bearer #{HUBSPOT_ACCESS_TOKEN}" }
    response = HTTParty.get(endpoint, headers: headers)

    unless response.success?
      Rails.logger.error("Failed to fetch signed-url for file_id #{file_id}: #{response.code} / #{response.body}")
      return nil
    end

    body = JSON.parse(response.body)
    return body["url"]
  end

  def self.download_and_attach(learner_info, download_url, document_type, description = nil)
    tempfile = Down.download(
      download_url,
      max_size: 200.megabytes,
      max_redirects: 5
    )

    filename = File.basename(URI.parse(download_url).path)
    content_type = Marcel::MimeType.for(tempfile, name: filename)

    if tempfile.size < 10.kilobytes
      Rails.logger.warn("Downloaded file is very small (#{tempfile.size} bytes) from #{download_url}")
    end
    unless content_type.start_with?("application/")
      Rails.logger.warn("Downloaded file content_type = #{content_type} from #{download_url}")
    end

    doc = learner_info.learner_documents.new(
      document_type: document_type,
      description: description,
      file_name: filename
    )
    doc.file.attach(
      io: tempfile,
      filename: filename,
      content_type: content_type
    )

    unless doc.save
      Rails.logger.error("Failed to save LearnerDocument: #{doc.errors.full_messages.join(', ')}")
    end
  rescue Down::Error => e
    Rails.logger.error("Failed to download file from #{download_url}: #{e.message}")
  end

  def self.fetch_submission_values(field_name)
    headers = {
      'Authorization' => "Bearer #{HUBSPOT_ACCESS_TOKEN}",
      'Content-Type'  => 'application/json'
    }

    Rails.logger.info("Fetching form definition from HubSpot API for field: #{field_name}...")
    response = HTTParty.get("https://api.hubapi.com/forms/v2/forms/#{FORM_GUID}", headers: headers)

    unless response.success?
      Rails.logger.error "HubSpot Form Definition API Error: #{response.code} - #{response.body}"
      return []
    end

    form_definition = JSON.parse(response.body)

    # Find the specific field within the form definition structure
    field = form_definition['formFieldGroups']
              .flat_map { |group| group['fields'] }
              .find { |f| f['name'] == field_name }

    unless field
      Rails.logger.error "HubSpot field '#{field_name}' not found in form definition."
      return []
    end

    options = field.dig('options')

    if options.present?
      # Return the 'value' property, as that's what is submitted
      submission_values = options.map { |option| option['value'] }.compact.uniq
      Rails.logger.info("Successfully fetched #{submission_values.count} submission values for #{field_name}.")
      return submission_values
    else
      Rails.logger.warn "HubSpot field '#{field_name}' does not appear to have options."
      return []
    end
  rescue => e
    Rails.logger.error "Error fetching HubSpot form options for #{field_name}: #{e.message}"
    return []
  end

  def self.normalize_email(raw)
    return nil if raw.blank?
    raw = raw.to_s.strip
    # Extract from <...> if fully wrapped (allowing spaces)
    if raw =~ /\A<\s*([^>]+)\s*>\z/
      raw = $1.strip
    end
    raw.downcase
  end

  def self.inspect_form_fields(form_guid)
    headers = {
      'Authorization' => "Bearer #{HUBSPOT_ACCESS_TOKEN}",
      'Content-Type'  => 'application/json'
    }

    response = HTTParty.get("https://api.hubapi.com/forms/v2/forms/#{form_guid}", headers: headers)

    unless response.success?
      puts "Error: #{response.code} - #{response.body}"
      return
    end

    form_definition = JSON.parse(response.body)

    fields_summary = form_definition['formFieldGroups'].flat_map { |g| g['fields'] }.map do |f|
      {
        name: f['name'],
        label: f['label'],
        type: f['fieldType'],
        options: f['options']&.map { |o| o['value'] }
      }
    end

    puts "--- Form Fields for GUID: #{form_guid} ---"
    fields_summary.each do |f|
      puts "Field: #{f[:name]}"
      puts "Label: #{f[:label]}"
      puts "Type:  #{f[:type]}"
      puts "Options: #{f[:options].join(', ')}" if f[:options].present?
      puts "-" * 30
    end

    fields_summary
  end
end
