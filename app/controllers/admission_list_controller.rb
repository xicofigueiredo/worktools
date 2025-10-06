class AdmissionListController < ApplicationController
  # TODO: Add permissions
  before_action :set_learner_info, only: [:show, :update, :documents, :create_document, :destroy_document, :download_document]

  def index
    @statuses  = LearnerInfo.distinct.pluck(:status).compact.sort
    @curricula = LearnerInfo.distinct.pluck(:curriculum_course_option).compact.sort
    @grades    = LearnerInfo.distinct.pluck(:grade_year).compact.sort

    scope = LearnerInfo.select(:id, :full_name, :curriculum_course_option, :grade_year)

    scope = scope.where(status: params[:status]) if params[:status].present?
    scope = scope.where(curriculum_course_option: params[:curriculum]) if params[:curriculum].present?
    scope = scope.where(grade_year: params[:grade_year]) if params[:grade_year].present?

    scope = scope.order(Arel.sql("COALESCE(student_number, 99999999), id"))

    @learner_infos = scope
  end

  def show
    @learner_info = LearnerInfo.includes(:user).find(params[:id])
    excluded = %w[id user_id created_at updated_at]
    @show_columns = LearnerInfo.column_names - excluded
  end

  def update
    if @learner_info.update(learner_info_params)
      # log the change (pass current_user)
      begin
        @learner_info.log_update(current_user, @learner_info.saved_changes)
      rescue => e
        Rails.logger.error "Failed to create learner_info log: #{e.class}: #{e.message}"
      end

      flash[:notice] = "Learner updated successfully."
      redirect_to admission_path(@learner_info)
    else
      flash.now[:alert] = "There were errors updating the learner: " + @learner_info.errors.full_messages.to_sentence
      @show_attributes = LearnerInfo.column_names - %w[id user_id created_at updated_at]
      render :show, status: :unprocessable_entity
    end
  end

  def documents
    @documents = @learner_info.learner_documents.order(:document_type)
    respond_to do |format|
      format.html { redirect_to admission_path(@learner_info) }
      format.js
    end
  end

  def create_document
    permitted = params.require(:learner_document).permit(:document_type, :description, file: [])

    unless LearnerDocument::DOCUMENT_TYPES.include?(permitted[:document_type])
      flash[:alert] = "Invalid document type"
      return redirect_to admission_path(@learner_info)
    end

    files = Array.wrap(permitted[:file]).compact
    if files.blank?
      flash[:alert] = "No file selected"
      return redirect_to admission_path(@learner_info, active_tab: 'documents')
    end

    saved_docs = []
    files.each do |file|
      document = @learner_info.learner_documents.build(
        document_type: permitted[:document_type],
        description: permitted[:description]
      )
      document.file.attach(file)
      if document.save
        saved_docs << document
      else
        flash[:alert] = document.errors.full_messages.to_sentence
        return redirect_to admission_path(@learner_info, active_tab: 'documents')
      end
    end

    # Log the upload(s)
    begin
      changed_data = saved_docs.map do |doc|
        {
          'document_type' => doc.document_type,
          'filename' => doc.file.filename.to_s,
          'blob_id' => doc.file.blob.id
        }
      end
      @learner_info.learner_info_logs.create!(
        user: current_user,
        action: 'document_upload',
        changed_fields: [],
        changed_data: changed_data,
        note: "Uploaded #{saved_docs.size} file(s) for #{saved_docs.first.human_type}"
      )
    rescue => e
      Rails.logger.error "Failed to log document upload: #{e.class}: #{e.message}"
    end

    flash[:notice] = "#{saved_docs.first.human_type} uploaded (#{saved_docs.size} file(s))."
    redirect_to admission_path(@learner_info, active_tab: 'documents')
  end

  def destroy_document
    @document = @learner_info.learner_documents.find(params[:document_id])

    filename = @document.file.attached? ? @document.file.filename.to_s : nil
    doc_type = @document.document_type
    human_type = @document.human_type

    @document.file.purge if @document.file.attached?
    @document.destroy

    # Log deletion
    begin
      @learner_info.learner_info_logs.create!(
        user: current_user,
        action: 'document_delete',
        changed_fields: [],
        changed_data: {
          'document_type' => doc_type,
          'filename' => filename
        },
        note: "Removed #{human_type}"
      )
    rescue => e
      Rails.logger.error "Failed to log document deletion: #{e.class}: #{e.message}"
    end

    flash[:notice] = "#{human_type} removed."
    redirect_to admission_path(@learner_info, active_tab: 'documents')
  end

  private

  def set_learner_info
    @learner_info = LearnerInfo.find(params[:id])
  end

  def learner_info_params
    params.require(:learner_info).permit(
      :programme,
      :full_name,
      :curriculum_course_option,
      :grade_year,
      :start_date,
      :transfer_of_programme_date,
      :end_date,
      :end_day_communication,
      :personal_email,
      :phone_number,
      :id_information,
      :fiscal_number,
      :home_address,
      :gender,
      :use_of_image_authorisation,
      :emergency_protocol_choice,
      :parent1_email,
      :parent1_phone_number,
      :parent1_id_information,
      :parent2_email,
      :parent2_phone_number,
      :parent2_id_information,
      :parent2_info_not_to_be_contacted,
      :deposit,
      :sponsor,
      :payment_plan,
      :discount_mt,
      :scholarship_percentage,
      :discount_af,
      :withdrawal_reason,
      :personal_email,
      :preferred_name,
      :native_language
    )
  end
end
