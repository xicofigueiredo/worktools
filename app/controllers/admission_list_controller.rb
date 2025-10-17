require 'csv'

class AdmissionListController < ApplicationController
  before_action :set_learner_info, only: [:show, :update, :documents, :create_document, :destroy_document, :check_pricing_impact]

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
    head :forbidden and return unless @permission.show?

    @learner_finance = @learner_info.learner_finance

    @main_hub = UsersHub.includes(:hub).find_by(user_id: @learner_info.user_id, main: true)&.hub
    @currency_symbol = '€'
    if @main_hub
      # Fetch any pricing tier for the hub's country to extract currency symbol
      pricing_tier = PricingTier.where(country: @main_hub.country).first
      if pricing_tier && pricing_tier.currency
        match = pricing_tier.currency.match(/\(([^)]+)\)/)
        @currency_symbol = match ? match[1] : '€'
      end
    end

    excluded = %w[id user_id created_at updated_at]
    @show_columns = LearnerInfo.column_names - excluded
  end

  def update
    head :forbidden and return unless @permission.update?

    # Proceed with update
    if @learner_info.update(learner_info_params_from_permission)
      begin
        @learner_info.log_update(current_user, @learner_info.saved_changes)

        # Log finance changes if any
        if @learner_info.learner_finance&.saved_changes&.any?
          finance_changes = @learner_info.learner_finance.saved_changes.except('updated_at')
          if finance_changes.any?
            @learner_info.learner_info_logs.create!(
              user: current_user,
              action: 'finance_update',
              changed_fields: finance_changes.keys,
              changed_data: finance_changes.transform_values { |v| { 'from' => v[0], 'to' => v[1] } },
              note: "Finance information updated"
            )
          end
        end
      rescue => e
        Rails.logger.error "Failed to create learner_info log: #{e.class}: #{e.message}"
      end

      flash[:notice] = "Learner updated successfully."
      redirect_to admission_path(@learner_info)
    else
      flash.now[:alert] = "There were errors updating the learner: " + @learner_info.errors.full_messages.to_sentence
      @show_attributes = LearnerInfo.column_names - %w[id user_id created_at updated_at]
      @learner_finance = @learner_info.learner_finance
      render :show, status: :unprocessable_entity
    end
  end

  # Update learner_info_params_from_permission to include nested attributes
  def learner_info_params_from_permission
    permitted = Array(@permission&.permitted_attributes).map(&:to_sym)
    finance_permitted = Array(@permission&.finance_permitted_attributes).map(&:to_sym)

    permitted = [] if permitted.blank?

    if params[:learner_info].present?
      # Build the permit hash
      permit_hash = permitted.dup

      # Add nested finance attributes if finance permissions exist
      if finance_permitted.any?
        # Always include :id for nested attributes to work properly
        permit_hash << { learner_finance_attributes: [:id] + finance_permitted }
      end

      Rails.logger.debug "Permitting params: #{permit_hash.inspect}"
      params.require(:learner_info).permit(permit_hash)
    else
      {}
    end
  end

  def check_pricing_impact
    head :forbidden and return unless @permission.show?

    curriculum = params[:curriculum]
    programme = params[:programme]
    hub_id = params[:hub_id]

    if curriculum.blank? || hub_id.blank?
      return render json: { error: 'Missing curriculum or hub_id' }, status: :bad_request
    end

    hub = Hub.find_by(id: hub_id)
    unless hub
      return render json: { error: 'Hub not found' }, status: :not_found
    end

    # Compute model based on programme and hub (same as matcher)
    model = if programme&.start_with?('Online:')
      'online'
    elsif programme&.start_with?('In-Person:')
      'hybrid'
    else
      hub.name.downcase == 'remote' ? 'online' : 'hybrid'
    end

    # Get new pricing for the selected curriculum and programme
    new_pricing = PricingTierMatcher.for_learner(@learner_info, curriculum, hub, programme)

    # Get current finance values
    current_finance = @learner_info.learner_finance || @learner_info.build_learner_finance

    current_pricing = {
      monthly_fee: current_finance.monthly_fee,
      admission_fee: current_finance.admission_fee,
      renewal_fee: current_finance.renewal_fee,
      discount_mf: current_finance.discount_mf,
      scholarship: current_finance.scholarship,
      discount_af: current_finance.discount_af,
      discount_rf: current_finance.discount_rf
    }

    if new_pricing.nil?
      return render json: {
        requires_confirmation: false,
        error: 'No pricing tier found for this combination'
      }
    end

    # Always require confirmation if pricing tier found (since called on change)
    render json: {
      requires_confirmation: true,
      new_curriculum: curriculum,
      old_programme: @learner_info.programme,
      new_programme: programme,
      pricing_criteria: {
        model: model.capitalize,
        country: hub.country,
        hub_name: hub.name,
        curriculum: curriculum
      },
      current_pricing: current_pricing,
      new_pricing: {
        monthly_fee: new_pricing.monthly_fee,
        admission_fee: new_pricing.admission_fee,
        renewal_fee: new_pricing.renewal_fee
      }
    }
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
    @visible_learner_fields = @permission.visible_learner_fields
    @visible_finance_fields = @permission.visible_finance_fields

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
    visible_learner_fields = @permission.visible_learner_fields
    visible_finance_fields = @permission.visible_finance_fields

    # Get selected fields from form
    selected_fields = params[:fields]&.select { |f| visible_learner_fields.include?(f.to_sym) || visible_finance_fields.include?(f.to_sym) } || []

    if selected_fields.empty?
      flash[:alert] = "Please select at least one field to export"
      return redirect_to admissions_path
    end

    # Build scope
    filter_scope = LearnerInfo.includes(:learner_finance)

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
        row = selected_fields.map do |field|
          field_sym = field.to_sym
          if visible_learner_fields.include?(field_sym)
            learner.send(field)
          elsif visible_finance_fields.include?(field_sym)
            learner.learner_finance&.send(field)
          else
            nil
          end
        end
        csv << row
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
    finance_permitted = Array(@permission&.finance_permitted_attributes).map(&:to_sym)
    permitted = [] if permitted.blank?

    if params[:learner_info].present?
      # Start with base permitted attributes
      permit_hash = permitted.dup

      # Add virtual attribute if institutional_email is editable
      if permitted.include?(:institutional_email)
        permit_hash << :institutional_email_prefix
      end

      # Add nested learner_finance_attributes if any finance fields are permitted
      if finance_permitted.any?
        permit_hash << { learner_finance_attributes: [:id] + finance_permitted }
      end

      # Optional: Log for debugging
      Rails.logger.debug "Permitted params: #{permit_hash.inspect}"

      params.require(:learner_info).permit(*permit_hash)
    else
      {}
    end
  end
end
