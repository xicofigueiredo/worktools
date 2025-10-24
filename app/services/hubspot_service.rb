class HubspotService
  HUBSPOT_ACCESS_TOKEN = ENV['HUBSPOT_ACCESS_TOKEN']
  FORM_GUID = '472b7df8-5290-4908-8408-1dcee6e15512'
  API_URL = "https://api.hubapi.com/form-integrations/v1/submissions/forms/#{FORM_GUID}"

  def self.fetch_new_submissions
    headers = {
      'Authorization' => "Bearer #{HUBSPOT_ACCESS_TOKEN}",
      'Content-Type'  => 'application/json'
    }

    response = HTTParty.get(API_URL, query: { limit: 50 }, headers: headers)

    unless response.success?
      Rails.logger.error "HubSpot API Error: #{response.code} - #{response.body}"
      return false
    end

    data = JSON.parse(response.body)
    data['results'].each { |submission| process_submission(submission) }

    Rails.logger.info "Successfully processed #{data['results'].count} new submissions."
    true
  end

  def self.process_submission(submission_data)
    fields = submission_data['values'].map { |v| [v['name'].to_sym, v['value']] }.to_h
    email  = fields[:learner_s_personal_email_address]

    Rails.logger.info("All submission fields: #{fields.inspect}")
    Rails.logger.info("Processing submission for email: #{email} at #{Time.zone.at(submission_data['submittedAt']/1000.0)}")

    # Skip existing leads
    if LearnerInfo.find_by(personal_email: email.strip.presence&.downcase).present?
      Rails.logger.warn("Skipping submission: LearnerInfo with email #{email} already exists.")
      return
    end

    learner_info = create_learner_info(fields)
    unless learner_info
      Rails.logger.error("Failed to create LearnerInfo for submission with email #{email}")
      return
    end

    begin
      associate_hub(learner_info, fields)
    rescue => e
      Rails.logger.error("Error associating hub for LearnerInfo ID=#{learner_info.id}: #{e.message}")
    end

    # New logic: Set status based on hub capacity after association
    if learner_info.hub_id.present?
      hub = learner_info.hub
      active_count = LearnerInfo.where(hub_id: hub.id).where.not(id: learner_info.id).where.not(status: ['Inactive', 'Graduated']).count

      if active_count < hub.capacity
        learner_info.update!(status: 'In progress')
        Rails.logger.info("Set status to 'In progress' for LearnerInfo ID: #{learner_info.id} (hub has capacity)")
      else
        learner_info.update!(status: 'Waitlist')
        Rails.logger.info("Set status to 'Waitlist' for LearnerInfo ID: #{learner_info.id} (hub at capacity)")
      end
    else
      Rails.logger.warn("No hub associated for LearnerInfo ID: #{learner_info.id} - Status remains 'New Lead'")
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

  def self.associate_hub(learner_info, fields)
    hubspot_key = fields[:hub_interest_portugal]

    if hubspot_key.present?
      hub = Hub.find_by(hubspot_key: hubspot_key)
      if hub
        learner_info.update!(hub_id: hub.id)
        Rails.logger.info("Associated hub '#{hub.name}' (ID: #{hub.id}) with LearnerInfo ID: #{learner_info.id}")
      else
        Rails.logger.warn("No hub found for hubspot_key: #{hubspot_key} - LearnerInfo ID: #{learner_info.id} remains without hub association.")
      end
    else
      online_hub = Hub.find_by(name: "Online")
      if online_hub
        learner_info.update!(hub_id: online_hub.id)
        Rails.logger.info("Associated 'Online' hub (ID: #{online_hub.id}) with LearnerInfo ID: #{learner_info.id} (no hub_interest_portugal provided).")
      else
        Rails.logger.warn("No 'Online' hub found - LearnerInfo ID: #{learner_info.id} remains without hub association.")
      end
    end
  end

  def self.create_learner_info(fields)
    learner_info_mapping = {
      :learning_model                    => :programme,
      :curriculum_option__2_             => :curriculum_course_option,
      :current_school_grade_year         => :previous_school_grade_year,
      :previous_school_status            => :previous_school_status,
      :previous_school_s_name            => :previous_school_name,
      :previous_school_s_email           => :previous_school_email,
      :studentname                       => :full_name,
      :learner_s_personal_email_address  => :personal_email,
      :learner_s_phone_number__2_        => :phone_number,
      :learner_s_date_of_birth           => :birthdate,
      :learner_s_nationality             => :nationality,
      :learner_s_id_document__name_and_type_ => :id_information,
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
      if model_col == :birthdate
          timestamp_seconds = val.to_i / 1000
          val = Time.at(timestamp_seconds).to_date
          val = (Date.parse(val) rescue val)
      end
      attrs[model_col] = val
    end

    # Special handling for UP Programme
    if attrs[:programme] == "UP Programme (Higher Education)" && fields[:level].present?
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

    learner_info = LearnerInfo.new(attrs)

    if learner_info.save
      Rails.logger.info("Successfully created NEW LearnerInfo for #{learner_info.full_name} (ID: #{learner_info.id})")
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

    # Fetch pricing tier if hub is associated
    if learner_info.hub
      hub = learner_info.hub
      program = (hub.name == "Online") ? "Online" : "Hybrid"
      country = hub.country
      hub_type = hub.hub_type
      specific_hub = ["Sommerschield", "Tofo", "DHS", "HHS"].include?(hub.name) ? hub.name : "N/A"
      curriculum = learner_info.curriculum_course_option

      if country && hub_type && curriculum
        tier = PricingTier.find_by(
          model: program,
          country: country,
          hub_type: hub_type,
          specific_hub: specific_hub,
          curriculum: curriculum
        )

        if tier
          finance_attrs[:monthly_fee] = tier.monthly_fee
          finance_attrs[:admission_fee] = tier.admission_fee
          finance_attrs[:renewal_fee] = tier.renewal_fee
          Rails.logger.info("Applied pricing tier for LearnerInfo ID: #{learner_info.id} - Monthly: #{tier.monthly_fee}, Admission: #{tier.admission_fee}, Renewal: #{tier.renewal_fee}")
        else
          Rails.logger.warn("No matching pricing tier found for LearnerInfo ID: #{learner_info.id} (program: #{program}, country: #{country}, hub_type: #{hub_type}, specific_hub: #{specific_hub}, curriculum: #{curriculum})")
        end
      else
        Rails.logger.warn("Insufficient data to fetch pricing tier for LearnerInfo ID: #{learner_info.id}")
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
      special_education_form:        'special_needs',
      learner_s_id_document_picture: 'learner_id',
      letter_of_interest:            'letter_of_interest',
      picture:                       'picture',
      medical_form:                  'medical_form',
      parent_1_id_document_picture:  'parent_id',
      parent_2_id_document_photo:    'parent_id'
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

  def self.fetch_hub_submission_values
    headers = {
      'Authorization' => "Bearer #{HUBSPOT_ACCESS_TOKEN}",
      'Content-Type'  => 'application/json'
    }

    Rails.logger.info("Fetching form definition from HubSpot API...")
    response = HTTParty.get("https://api.hubapi.com/forms/v2/forms/#{FORM_GUID}", headers: headers)

    unless response.success?
      Rails.logger.error "HubSpot Form Definition API Error: #{response.code} - #{response.body}"
      return []
    end

    form_definition = JSON.parse(response.body)
    field_name = 'hub_interest_portugal'

    # Find the specific field within the form definition structure
    hub_field = form_definition['formFieldGroups']
                  .flat_map { |group| group['fields'] }
                  .find { |field| field['name'] == field_name }

    unless hub_field
      Rails.logger.error "HubSpot field '#{field_name}' not found in form definition."
      return []
    end

    options = hub_field.dig('options')

    if options.present?
      # 🚨 The key part: Return the 'value' property, not the 'label'.
      # The 'value' is what HubSpot stores and sends in the submission.
      submission_values = options.map { |option| option['value'] }.compact.uniq
      Rails.logger.info("Successfully fetched #{submission_values.count} submission values for #{field_name}.")
      return submission_values
    else
      Rails.logger.warn "HubSpot field '#{field_name}' does not appear to have options."
      return []
    end
  rescue => e
    Rails.logger.error "Error fetching HubSpot form options: #{e.message}"
    return []
  end
end
