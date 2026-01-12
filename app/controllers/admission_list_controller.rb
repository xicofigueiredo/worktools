require 'csv'

class AdmissionListController < ApplicationController
  before_action :set_learner_info, only: [:show, :update, :documents, :create_document, :destroy_document, :update_document, :check_pricing_impact]
  before_action :set_learning_coaches, only: [:show]
  before_action :require_staff
  before_action :require_admin_or_admissions, only: [:fetch_from_hubspot]

  def index
    if params[:reset].present?
      session.delete(:admission_filters)
      redirect_to admissions_path and return
    end

    filter_keys = [:search, :status, :hub, :programme, :curriculum, :grade_year, :age_min, :age_max]

    has_active_filters = params[:filter_applied].present? || filter_keys.any? { |k| params[k].present? }

    if has_active_filters
      session[:admission_filters] = params.permit(
        :filter_applied,
        :search,
        status: [],
        hub: [],
        programme: [],
        curriculum: [],
        grade_year: []
      ).to_h
    elsif session[:admission_filters].present? && request.format.html?
      redirect_to admissions_path(session[:admission_filters]) and return
    end

    @statuses  = LearnerInfo.distinct.pluck(:status).compact.sort
    @curricula = LearnerInfo.distinct.pluck(:curriculum_course_option).compact.sort
    @grades    = LearnerInfo.distinct.pluck(:grade_year).compact.sort
    @programmes = LearnerInfo.distinct.pluck(:programme).compact.sort

    # Determine hubs scope (limit for LC users)
    hubs_scope = Hub.all
    lc_hub_ids = nil
    if current_user.lc?
      lc_hub_ids = current_user.users_hubs.pluck(:hub_id)
      hubs_scope = hubs_scope.where(id: lc_hub_ids) if lc_hub_ids.any?
    end

    # Prepare grouped hubs (assume Hub has :country column)
    hubs_data = hubs_scope.select(:country, :name).distinct.order(:country, :name)
    @hubs_grouped = hubs_data.group_by { |h| h.country || 'Other' }
    @hubs_grouped.transform_values! { |v| v.map { |h| [h.name, h.name] } }

    # build a scope purely for filtering/counting (no select/order)
    filter_scope = LearnerInfo.all

    # LC only see hub learners
    if current_user.lc?
      if lc_hub_ids.any?
        filter_scope = filter_scope.where(
          "(learner_infos.hub_id IN (:hub_ids)) OR " \
          "(learner_infos.learning_coach_id = :user_id) OR " \
          "(learner_infos.hub_id IS NULL AND EXISTS (" \
            "SELECT 1 FROM users_hubs uh " \
            "WHERE uh.user_id = learner_infos.user_id " \
            "AND uh.hub_id IN (:hub_ids) " \
            "AND uh.main = TRUE" \
          "))",
          hub_ids: lc_hub_ids,
          user_id: current_user.id
        )
      else

        filter_scope = filter_scope.where(learning_coach_id: current_user.id)
      end
    end

    # Search filter
    if params[:search].present?
      search_term = "%#{params[:search].strip}%"
      filter_scope = filter_scope.where(
        "full_name ILIKE :search OR personal_email ILIKE :search OR institutional_email ILIKE :search OR " \
        "parent1_full_name ILIKE :search OR parent1_email ILIKE :search OR " \
        "parent2_full_name ILIKE :search OR parent2_email ILIKE :search",
        search: search_term
      )
    end

    # Multi-select filters
    if params[:status].present?
      statuses = Array(params[:status]).reject(&:blank?)
      filter_scope = filter_scope.where(status: statuses) if statuses.any?
    end

    if params[:curriculum].present?
      curricula = Array(params[:curriculum]).reject(&:blank?)
      filter_scope = filter_scope.where(curriculum_course_option: curricula) if curricula.any?
    end

    if params[:grade_year].present?
      grades = Array(params[:grade_year]).reject(&:blank?)
      filter_scope = filter_scope.where(grade_year: grades) if grades.any?
    end

    if params[:programme].present?
      programmes = Array(params[:programme]).reject(&:blank?)
      filter_scope = filter_scope.where(programme: programmes) if programmes.any?
    end

    if params[:hub].present?
      hub_names = Array(params[:hub]).reject(&:blank?)
      if hub_names.any?
        hubs = Hub.where(name: hub_names)
        if hubs.any?
          hub_ids = hubs.pluck(:id)
          filter_scope = filter_scope.where(
            "(learner_infos.hub_id IN (:hub_ids)) OR (learner_infos.hub_id IS NULL AND EXISTS (SELECT 1 FROM users_hubs uh WHERE uh.user_id = learner_infos.user_id AND uh.hub_id IN (:hub_ids) AND uh.main = TRUE))",
            hub_ids: hub_ids
          )
        else
          filter_scope = filter_scope.where("1 = 0")
        end
      end
    end

    # Age Range Logic
    if params[:age_min].present? || params[:age_max].present?
      # Default values if one is missing
      min_age = params[:age_min].presence || 0
      max_age = params[:age_max].presence || 25

      # PostgreSQL calculation for age: EXTRACT(YEAR FROM AGE(birthdate))
      filter_scope = filter_scope.where(
        "EXTRACT(YEAR FROM AGE(birthdate)) BETWEEN ? AND ?",
        min_age.to_i,
        max_age.to_i
      )
    end

    # counts
    @total_count    = LearnerInfo.count
    @filtered_count = filter_scope.count

    hub_name_subquery = <<~SQL.squish
      CASE
        WHEN learner_infos.hub_id IS NOT NULL THEN (SELECT name FROM hubs WHERE id = learner_infos.hub_id LIMIT 1)
        ELSE (SELECT hubs.name FROM hubs JOIN users_hubs uh ON uh.hub_id = hubs.id WHERE uh.user_id = learner_infos.user_id AND uh.main = TRUE LIMIT 1)
      END AS hub_name
    SQL

    hub_id_subquery = <<~SQL.squish
      CASE
        WHEN learner_infos.hub_id IS NOT NULL THEN learner_infos.hub_id
        ELSE (SELECT hubs.id FROM hubs JOIN users_hubs uh ON uh.hub_id = hubs.id WHERE uh.user_id = learner_infos.user_id AND uh.main = TRUE LIMIT 1)
      END AS hub_id
    SQL

    has_debt_subquery = <<~SQL.squish
      (SELECT lf.has_debt FROM learner_finances lf WHERE lf.learner_info_id = learner_infos.id LIMIT 1) AS has_debt
    SQL

    # final scope used to render table (add select/order as you had before)
    scope = filter_scope.select(:id, :full_name, :curriculum_course_option, :grade_year, :student_number, :status, :programme, Arel.sql(hub_id_subquery), Arel.sql(hub_name_subquery), Arel.sql(has_debt_subquery))
    scope = scope.order(Arel.sql("COALESCE(student_number, 99999999), id"))

    @learner_infos = scope.reverse
  end

  def show
    head :forbidden and return unless @permission.show?

    @learner_finance = @learner_info.learner_finance

    @main_hub = @learner_info.hub || PricingTierMatcher.get_main_hub_for_learner(@learner_info)

    @currency_symbol = '€'
    if @learner_info.hub.presence
      hub = @learner_info.hub
      if %w[Online Remote\ 1 Remote\ 2 Remote\ 3 Undetermined].include?(hub.name)
        @currency_symbol = '$'
      else
        # Fetch any pricing tier for the hub's country to extract currency symbol
        pricing_tier = PricingTier.where(country: @learner_info.hub.country).first
        if pricing_tier && pricing_tier.currency
          match = pricing_tier.currency.match(/\(([^)]+)\)/)
          @currency_symbol = match ? match[1] : '€'
        end
      end
    end

    # Prepare hub options based on programme type
    @online_hubs = Hub.where(hub_type: 'Online').pluck(:name, :id)
    @hybrid_hubs = Hub.where.not(hub_type: 'Online').pluck(:name, :id)

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

  def new
    head :forbidden and return unless current_user.admin? || current_user.admissions?

    @learner_info = LearnerInfo.new
    @learner_finance = @learner_info.build_learner_finance
    @permission = LearnerInfoPermission.new(current_user, @learner_info)

    @online_hubs = Hub.where(hub_type: 'Online').pluck(:name, :id)
    @hybrid_hubs = Hub.where.not(hub_type: 'Online').pluck(:name, :id)
    @currency_symbol = '€'

    render :show
  end

  def create
    head :forbidden and return unless current_user.admin? || current_user.admissions?

    @learner_info = LearnerInfo.new
    @permission = LearnerInfoPermission.new(current_user, @learner_info)
    @learner_info.assign_attributes(learner_info_params_from_permission)

    if @learner_info.save
      @learner_info.log_update(current_user, @learner_info.saved_changes, note: "Manual creation")
      flash[:notice] = "Learner created successfully."
      redirect_to admission_path(@learner_info)
    else
      @permission = LearnerInfoPermission.new(current_user, @learner_info)
      @online_hubs = Hub.where(hub_type: 'Online').pluck(:name, :id)
      @hybrid_hubs = Hub.where.not(hub_type: 'Online').pluck(:name, :id)
      render :show, status: :unprocessable_entity
    end
  end

  def check_pricing_impact
    head :forbidden and return unless @permission.show?

    curriculum = params[:curriculum]
    hub_id = params[:hub_id]

    Rails.logger.info("check_pricing_impact called with: curriculum=#{curriculum}, hub_id=#{hub_id}")

    if curriculum.blank? || hub_id.blank?
      return render json: { error: 'Missing curriculum or hub_id' }, status: :bad_request
    end

    hub = Hub.find_by(id: hub_id)
    unless hub
      return render json: { error: 'Hub not found' }, status: :not_found
    end

    # Get new pricing for the selected combination
    new_pricing = PricingTierMatcher.for_learner(@learner_info, curriculum, hub)

    # Get or build current finance values
    current_finance = @learner_info.learner_finance || @learner_info.build_learner_finance

    current_pricing = {
      monthly_fee: current_finance.monthly_fee || 0,
      admission_fee: current_finance.admission_fee || 0,
      renewal_fee: current_finance.renewal_fee || 0,
      discount_mf: current_finance.discount_mf || 0,
      scholarship: current_finance.scholarship || 0,
      discount_af: current_finance.discount_af || 0,
      discount_rf: current_finance.discount_rf || 0
    }

    if new_pricing.nil?
      return render json: {
        requires_confirmation: false,
        error: "No pricing tier found for this combination (#{new_pricing.model} / #{hub.country} / #{curriculum}). Please contact administration."
      }
    end

    # Check if pricing actually changed
    pricing_changed = (
      current_finance.monthly_fee != new_pricing.monthly_fee ||
      current_finance.admission_fee != new_pricing.admission_fee ||
      current_finance.renewal_fee != new_pricing.renewal_fee
    )

    # Always show confirmation if:
    # 1. Finance doesn't exist yet (new record)
    # 2. Pricing has changed
    requires_confirmation = current_finance.new_record? || pricing_changed

    Rails.logger.info("Pricing comparison: changed=#{pricing_changed}, new_record=#{current_finance.new_record?}, requires_confirmation=#{requires_confirmation}")

    # Calculate new currency symbol based on the same logic as in show action
    new_currency_symbol = '€'
    if %w[Online Remote\ 1 Remote\ 2 Remote\ 3 Undetermined].include?(hub.name)
      new_currency_symbol = '$'
    else
      match = new_pricing.currency.match(/\(([^)]+)\)/) if new_pricing.currency
      new_currency_symbol = match ? match[1] : '€'
    end

    render json: {
      requires_confirmation: requires_confirmation,
      new_curriculum: curriculum,
      new_hub_name: hub.name,
      pricing_criteria: {
        model: new_pricing.model,
        country: hub.country,
        hub_name: hub.name,
        curriculum: curriculum
      },
      current_pricing: current_pricing,
      new_pricing: {
        monthly_fee: new_pricing.monthly_fee,
        admission_fee: new_pricing.admission_fee,
        renewal_fee: new_pricing.renewal_fee
      },
      new_currency_symbol: new_currency_symbol
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

  def update_document
    @document = @learner_info.learner_documents.find(params[:document_id])
    doc_perm = LearnerDocumentPermission.new(current_user, @document)

    unless doc_perm.update?
      return redirect_to admission_path(@learner_info, active_tab: 'documents'), alert: "Not authorized to update this document."
    end

    permitted = params.require(:learner_document).permit(:description)

    old_description = @document.description
    if @document.update(permitted)
      # Log update if changed
      if @document.description != old_description
        begin
          @learner_info.learner_info_logs.create!(
            user: current_user,
            action: 'document_update',
            changed_fields: ['description'],
            changed_data: {
              'document_type' => @document.document_type,
              'old_description' => old_description,
              'new_description' => @document.description
            },
            note: "Updated description for #{@document.human_type}"
          )
        rescue => e
          Rails.logger.error "Failed to log document update: #{e.class}: #{e.message}"
        end
      end

      flash[:notice] = "Description updated."
    else
      flash[:alert] = @document.errors.full_messages.to_sentence
    end

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

    if params[:age_min].present? || params[:age_max].present?
      min_age = params[:age_min].presence || 0
      max_age = params[:age_max].presence || 50
      filter_scope = filter_scope.where("EXTRACT(YEAR FROM AGE(birthdate)) BETWEEN ? AND ?", min_age.to_i, max_age.to_i)
    end

    # Generate CSV
    csv_string = "\xEF\xBB\xBF" + CSV.generate(headers: true) do |csv|
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

  def fetch_from_hubspot
    begin
      # 1. Get the count of records BEFORE the sync
      initial_count = LearnerInfo.count

      # Call the service. This method should handle the actual creation/update of LearnerInfo records.
      HubspotService.fetch_new_submissions # The result of this is now ignored for the count

      # 2. Get the count of records AFTER the sync
      final_count = LearnerInfo.count

      # 3. Calculate the new count based on the difference
      new_count = final_count - initial_count

      message =
        if new_count.to_i > 0
          "Fetched #{new_count} new learner#{'s' if new_count.to_i != 1} from HubSpot."
        else
          "Already up to date."
        end

      # The controller sends the accurate 'message' string
      render json: { success: true, new_count: new_count.to_i, message: message }
    rescue => e
      Rails.logger.error "[fetch_from_hubspot] Error fetching from HubSpot: #{e.class}: #{e.message}\n#{e.backtrace.first(10).join("\n")}"
      render json: { success: false, error: "Failed to fetch from HubSpot: #{e.message}" }, status: :internal_server_error
    end
  end

  private

  def require_staff
    redirect_to root_path unless current_user&.staff?
  end

  def set_learner_info
    # include user for view convenience
    @learner_info = LearnerInfo.includes(:user).find(params[:id])
    @permission   = LearnerInfoPermission.new(current_user, @learner_info)
  end

  def set_learning_coaches
    # Get all LCs who can teach remote
    @remote_lcs = User.joins(:collaborator_info)
                            .where(role: 'lc', deactivate: false)
                            .where(collaborator_infos: { can_teach_remote: true })
                            .includes(:users_hubs)

    @remote_lcs = @remote_lcs.map do |lc|
      # Find the main hub for this lc
      main_users_hub = lc.users_hubs.find_by(main: true)
      main_hub = main_users_hub&.hub
      next unless main_hub

      # Use hub model methods
      lc_count = main_hub.learning_coaches_with_capacity.to_a.count
      kids_count = main_hub.learners_excluding_statuses(LearnerInfo::INACTIVE_STATUSES).count
      remote_count = LearnerInfo.where(learning_coach_id: lc.id).active.count

      # Calculate ratio
      base_ratio = lc_count.positive? ? (kids_count.to_f / lc_count) : 0.0
      ratio = base_ratio + remote_count

      {
        coach: lc,
        main_hub: main_hub,
        lc_count: lc_count,
        kids_count: kids_count,
        remote_count: remote_count,
        ratio: ratio
      }
    end.compact

    @remote_lcs.sort_by! { |data| data[:ratio] }
    @all_lcs = User.where(role: 'lc', deactivate: false).includes(:collaborator_info)
  end

  # Use permission-defined attributes for strong params
  def learner_info_params_from_permission
    permitted = Array(@permission&.permitted_attributes).map(&:to_sym)
    finance_permitted = Array(@permission&.finance_permitted_attributes).map(&:to_sym)

    permit_hash = permitted.dup

    # 1. Institutional email prefix
    permit_hash << :institutional_email_prefix if permitted.include?(:institutional_email)

    # 2. Nested finance
    permit_hash << { learner_finance_attributes: [:id] + finance_permitted } if finance_permitted.any?

    # 3. Learning Coach – always allow if user has edit permission
    permit_hash << :learning_coach_id if @permission.update?

    Rails.logger.debug "Permitting: #{permit_hash.inspect}"

    params[:learner_info].present? ? params.require(:learner_info).permit(*permit_hash) : {}
  end

  def require_admin_or_admissions
    unless current_user.admin? || current_user.admissions?
      render json: { success: false, message: 'Access denied.' }, status: :forbidden
    end
  end
end
