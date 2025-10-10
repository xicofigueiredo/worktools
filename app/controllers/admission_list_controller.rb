require 'csv'

class AdmissionListController < ApplicationController
  before_action :set_learner_info, only: [:show, :update, :documents, :create_document, :destroy_document]

  def index
    @statuses  = LearnerInfo.distinct.pluck(:status).compact.sort
    @curricula = LearnerInfo.distinct.pluck(:curriculum_course_option).compact.sort
    @grades    = LearnerInfo.distinct.pluck(:grade_year).compact.sort
    @programmes = LearnerInfo.distinct.pluck(:programme).compact.sort
    @hubs = Hub.order(:name).pluck(:name)

    # build a scope purely for filtering/counting (no select/order)
    filter_scope = LearnerInfo.all

    if params[:search].present?
      search_term = "%#{params[:search].strip}%"
      filter_scope = filter_scope.where(
        "full_name ILIKE :search OR personal_email ILIKE :search OR institutional_email ILIKE :search OR " \
        "parent1_full_name ILIKE :search OR parent1_email ILIKE :search OR " \
        "parent2_full_name ILIKE :search OR parent2_email ILIKE :search",
        search: search_term
      )
    end

    filter_scope = filter_scope.where(status: params[:status]) if params[:status].present?
    filter_scope = filter_scope.where(curriculum_course_option: params[:curriculum]) if params[:curriculum].present?
    filter_scope = filter_scope.where(grade_year: params[:grade_year]) if params[:grade_year].present?
    filter_scope = filter_scope.where(programme: params[:programme]) if params[:programme].present?
    if params[:hub].present?
      hub = Hub.find_by(name: params[:hub])
      if hub
        filter_scope = filter_scope.where(
          "EXISTS (SELECT 1 FROM users_hubs uh WHERE uh.user_id = learner_infos.user_id AND uh.hub_id = ? AND uh.main = TRUE)",
          hub.id
        )
      else
        filter_scope = filter_scope.where("1 = 0")
      end
    end

    # counts
    @total_count    = LearnerInfo.count
    @filtered_count = filter_scope.count

    hub_name_subquery = <<~SQL.squish
      (SELECT hubs.name
      FROM hubs
      JOIN users_hubs uh ON uh.hub_id = hubs.id
      WHERE uh.user_id = learner_infos.user_id AND uh.main = TRUE
      LIMIT 1) AS hub_name
    SQL

    hub_id_subquery = <<~SQL.squish
      (SELECT hubs.id
      FROM hubs
      JOIN users_hubs uh ON uh.hub_id = hubs.id
      WHERE uh.user_id = learner_infos.user_id AND uh.main = TRUE
      LIMIT 1) AS hub_id
    SQL

    # final scope used to render table (add select/order as you had before)
    scope = filter_scope.select(:id, :full_name, :curriculum_course_option, :grade_year, :student_number, :status, :programme,Arel.sql(hub_id_subquery), Arel.sql(hub_name_subquery))
    scope = scope.order(Arel.sql("COALESCE(student_number, 99999999), id"))

    @learner_infos = scope
  end

  def show
    # @learner_info and @permission set by before_action
    head :forbidden and return unless @permission.show?

    excluded = %w[id user_id created_at updated_at]
    @show_columns = LearnerInfo.column_names - excluded
  end

  def update
    # authorization
    head :forbidden and return unless @permission.update?

    if @learner_info.update(learner_info_params_from_permission)
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
    # show documents tab (AJAX or redirect back)
    head :forbidden and return unless @permission.show?

    @documents = @learner_info.learner_documents.order(:document_type)
    respond_to do |format|
      format.html { redirect_to admission_path(@learner_info) }
      format.js
    end
  end

  def create_document
    # validate params
    permitted = params.require(:learner_document).permit(:document_type, :description, file: [])
    doc_type = permitted[:document_type].to_s

    unless LearnerDocument::DOCUMENT_TYPES.include?(doc_type)
      flash[:alert] = "Invalid document type"
      return redirect_to admission_path(@learner_info)
    end

    # document-level permission: allow admin/admissions OR (edu and doc_type == 'last_term_report')
    doc_perm = LearnerDocumentPermission.new(current_user, nil)
    unless doc_perm.create?(doc_type)
      return redirect_to admission_path(@learner_info), alert: "Not authorized to upload this type of document."
    end

    files = Array.wrap(permitted[:file]).compact
    if files.blank?
      flash[:alert] = "No file selected"
      return redirect_to admission_path(@learner_info, active_tab: 'documents')
    end

    saved_docs = []
    files.each do |file|
      document = @learner_info.learner_documents.build(
        document_type: doc_type,
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
    doc_perm = LearnerDocumentPermission.new(current_user, @document)

    unless doc_perm.destroy?
      return redirect_to admission_path(@learner_info, active_tab: 'documents'), alert: "Not authorized to remove this document."
    end

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

  def export_form
    # Get permission for current user to know which fields they can see
    @permission = LearnerInfoPermission.new(current_user, nil)
    @visible_fields = @permission.visible_fields

    @statuses  = LearnerInfo.distinct.pluck(:status).compact.sort
    @curricula = LearnerInfo.distinct.pluck(:curriculum_course_option).compact.sort
    @grades    = LearnerInfo.distinct.pluck(:grade_year).compact.sort
    @programmes = LearnerInfo.distinct.pluck(:programme).compact.sort
    @hubs = Hub.order(:name).pluck(:name)

    # Render without layout for AJAX requests
    render layout: false
  end

  def export_csv
    @permission = LearnerInfoPermission.new(current_user, nil)
    visible_fields = @permission.visible_fields

    # Get selected fields from form
    selected_fields = params[:fields]&.select { |f| visible_fields.include?(f.to_sym) } || []

    if selected_fields.empty?
      flash[:alert] = "Please select at least one field to export"
      return redirect_to admissions_path
    end

    # Build scope
    filter_scope = LearnerInfo.all

    # Apply multi-select filters
    if params[:status].present? && params[:status].is_a?(Array)
      filter_scope = filter_scope.where(status: params[:status].reject(&:blank?))
    end

    if params[:curriculum].present? && params[:curriculum].is_a?(Array)
      filter_scope = filter_scope.where(curriculum_course_option: params[:curriculum].reject(&:blank?))
    end

    if params[:grade_year].present? && params[:grade_year].is_a?(Array)
      filter_scope = filter_scope.where(grade_year: params[:grade_year].reject(&:blank?))
    end

    if params[:programme].present? && params[:programme].is_a?(Array)
      filter_scope = filter_scope.where(programme: params[:programme].reject(&:blank?))
    end

    if params[:hub].present? && params[:hub].is_a?(Array)
      hub_names = params[:hub].reject(&:blank?)
      if hub_names.any?
        hubs = Hub.where(name: hub_names)
        if hubs.any?
          filter_scope = filter_scope.where(
            "EXISTS (SELECT 1 FROM users_hubs uh WHERE uh.user_id = learner_infos.user_id AND uh.hub_id IN (?) AND uh.main = TRUE)",
            hubs.pluck(:id)
          )
        else
          filter_scope = filter_scope.where("1 = 0")
        end
      end
    end

    # Generate CSV
    csv_string = CSV.generate(headers: true) do |csv|
      # Add headers (humanized field names)
      csv << selected_fields.map { |f| f.to_s.humanize }

      # Add data rows
      filter_scope.find_each do |learner|
        csv << selected_fields.map { |field| learner.send(field) }
      end
    end

    # Send file
    send_data csv_string,
      filename: "learners_export_#{Date.today.strftime('%Y%m%d')}.csv",
      type: 'text/csv',
      disposition: 'attachment'
  end

  private

  def set_learner_info
    # include user for view convenience
    @learner_info = LearnerInfo.includes(:user).find(params[:id])
    @permission   = LearnerInfoPermission.new(current_user, @learner_info)
  end

  # Use permission-defined attributes for strong params
  def learner_info_params_from_permission
    permitted = Array(@permission&.permitted_attributes).map(&:to_sym)
    permitted = [] if permitted.blank?

    if params[:learner_info].present?
      params.require(:learner_info).permit(permitted)
    else
      {}
    end
  end
end
