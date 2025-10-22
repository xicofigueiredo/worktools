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

    data['results'].each do |submission|
      process_submission(submission)
    end

    Rails.logger.info "Successfully processed #{data['results'].count} new submissions."
    return true
  end

  def self.process_submission(submission_data)
    fields = submission_data['values'].map { |v| [v['name'].to_sym, v['value']] }.to_h
    email = fields[:learner_s_personal_email_address]

    Rails.logger.info("All submission fields: #{fields.inspect}")
    Rails.logger.info("Processing submission for email: #{email} at #{Time.zone.at(submission_data['submittedAt']/1000.0)}")

    # Skip existing leads
    if LearnerInfo.find_by(personal_email: email).present?
      Rails.logger.warn("Skipping submission: LearnerInfo with email #{email} already exists.")
      return
    end

    # Define the field mapping
    learner_info_mapping = {
      :learning_model                    => :programme,
      # :hub_interest_portugal             => :hub_interest,
      :curriculum_option__2_             => :curriculum_course_option,
      :current_school_grade_year        => :previous_school_grade_year,
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

    learner_info_attrs = {}
    learner_info_mapping.each do |hubspot_key, model_column|
      next unless fields[hubspot_key].present?

      value = (model_column == :birthdate) ? (Date.parse(fields[hubspot_key]) rescue fields[hubspot_key]) : fields[hubspot_key]
      learner_info_attrs[model_column] = value
    end

    # Image Authorization (Boolean)
    consent_string = "I consent to the above mentioned conditions"
    image_consent = fields[:use_of_image_authorization].to_s == consent_string
    learner_info_attrs[:use_of_image_authorisation] = image_consent

    # Grade calculation using model's class method
    curriculum = learner_info_attrs[:curriculum_course_option]
    raw_grade_string = fields[:grade_year]

    if curriculum.present? && raw_grade_string.present?
      calculated_grade = LearnerInfo.calculate_grade_from_hubspot(raw_grade_string, curriculum)
      learner_info_attrs[:grade_year] = calculated_grade if calculated_grade.present?
    end

    # Address combination
    address_keys = [:address, :city, :zip, :country]
    if address_keys.any? { |k| fields[k].present? }
      address_parts = address_keys.map { |k| fields[k] }.compact.join(', ')
      learner_info_attrs[:home_address] = address_parts
    end

    # Create the new LearnerInfo record
    learner_info = LearnerInfo.new(learner_info_attrs)
    learner_info.status = 'New Lead'

    if learner_info.save
      Rails.logger.info("Successfully created NEW LearnerInfo for #{learner_info.full_name} (ID: #{learner_info.id})")

      # Process LearnerFinances
      payment_plan             = fields[:payment_plan]
      financial_responsibility = fields[:financial_responsibility]

      finance_record = learner_info.build_learner_finance(
        payment_plan: payment_plan,
        financial_responsibility: financial_responsibility
      )

      if fields[:learner_s_id_document_picture].present?
        url = fields[:learner_s_id_document_picture]
        file_id = extract_file_id_from_url(url)
        if file_id
          download_url = get_download_url_for_file(file_id)
          if download_url
            download_and_attach(learner_info, download_url, 'learner_id')
          else
            Rails.logger.error("Could not get download_url for file_id #{file_id}")
          end
        else
          Rails.logger.error("Could not extract file_id from url: #{url}")
        end
      end

      if finance_record.save
        Rails.logger.info("Successfully created LearnerFinances for LearnerInfo ID: #{learner_info.id}")
      else
        Rails.logger.error("Failed to save LearnerFinances for #{learner_info.full_name}: #{finance_record.errors.full_messages.join(', ')}")
      end

    else
      Rails.logger.error("FATAL ERROR: Failed to create LearnerInfo for #{learner_info_attrs[:full_name]}: #{learner_info.errors.full_messages.join(', ')}")
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
  end
end
