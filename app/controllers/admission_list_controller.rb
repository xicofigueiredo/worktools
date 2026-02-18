require 'csv'

class AdmissionListController < ApplicationController
  before_action :set_learner_info, only: [:show, :update, :documents, :create_document, :destroy_document, :update_document, :check_pricing_impact, :check_onboarding_status, :send_onboarding_email]
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

    # Setup dropdown data
    @statuses  = LearnerInfo.distinct.pluck(:status).compact.sort
    @curricula = LearnerInfo.distinct.pluck(:curriculum_course_option).compact.sort
    @grades    = LearnerInfo.distinct.pluck(:grade_year).compact.sort
    @programmes = LearnerInfo.distinct.pluck(:programme).compact.sort

    # Determine hubs scope
    hubs_scope = Hub.all
    if current_user.lc?
      lc_hub_ids = current_user.users_hubs.pluck(:hub_id)
      hubs_scope = hubs_scope.where(id: lc_hub_ids) if lc_hub_ids.any?
    end

    # Prepare grouped hubs
    hubs_data = hubs_scope.select(:country, :name).distinct.order(:country, :name)
    @hubs_grouped = hubs_data.group_by { |h| h.country || 'Other' }
    @hubs_grouped.transform_values! { |v| v.map { |h| [h.name, h.name] } }

    # Age Range Logic
    age_bounds = LearnerInfo.pluck(Arel.sql("MIN(EXTRACT(YEAR FROM AGE(birthdate))), MAX(EXTRACT(YEAR FROM AGE(birthdate)))")).first
    @db_min_age = age_bounds[0]&.to_i || 0
    @db_max_age = age_bounds[1]&.to_i || 50
    @current_min_age = params[:age_min].presence ? params[:age_min].to_i : @db_min_age
    @current_max_age = params[:age_max].presence ? params[:age_max].to_i : @db_max_age

    # Apply Filters via shared method
    filter_scope = apply_filters(LearnerInfo.all)

    # Counts
    @total_count    = LearnerInfo.count
    @filtered_count = filter_scope.count

    # Subqueries for display
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

    # Final scope used to render table
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
      sample_tier = PricingTier.find_by(country: hub.country)
      @currency_symbol = sample_tier&.currency_symbol || PricingTier::CURRENCY_MAPPING[hub.country] || '€'
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
    new_pricing = PricingTierMatcher.for_learner(@learner_info, curriculum, hub, Date.today.year)

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
    new_currency_symbol = new_pricing.currency_symbol || '€'

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
    age_bounds = LearnerInfo.pluck(Arel.sql("MIN(EXTRACT(YEAR FROM AGE(birthdate))), MAX(EXTRACT(YEAR FROM AGE(birthdate)))")).first
    @db_min_age = age_bounds[0]&.to_i || 0
    @db_max_age = age_bounds[1]&.to_i || 50

    # Render without layout for AJAX requests
    render layout: false
  end

  def generate_bulk_emails
    # 1. Apply filters to get the target population
    scope = apply_filters(LearnerInfo.all)

    # 2. Preload necessary associations
    scope = scope.includes(:learner_finance)

    emails = Set.new

    # 3. Collect emails based on params
    scope.find_each do |learner|
      if params[:include_personal_email] == 'true' && learner.personal_email.present?
        emails.add(learner.personal_email)
      end

      if params[:include_institutional_email] == 'true' && learner.institutional_email.present?
        emails.add(learner.institutional_email)
      end

      if params[:include_parent1] == 'true' && learner.parent1_email.present?
        emails.add(learner.parent1_email)
      end

      if params[:include_parent2] == 'true' && learner.parent2_email.present?
        emails.add(learner.parent2_email)
      end

      if params[:include_finance] == 'true' && learner.learner_finance&.financial_email.present?
        emails.add(learner.learner_finance.financial_email)
      end
    end

    render json: {
      count: emails.size,
      emails: emails.to_a.sort.join('; ')
    }
  end

  def export_csv
    @permission = LearnerInfoPermission.new(current_user, nil)
    visible_learner_fields = @permission.visible_learner_fields
    visible_finance_fields = @permission.visible_finance_fields
    mandatory_columns = [:status, :hub_name, :hub_country]

    selected_fields = params[:fields]&.select { |f| visible_learner_fields.include?(f.to_sym) || visible_finance_fields.include?(f.to_sym) } || []

    if selected_fields.empty?
      flash[:alert] = "Please select at least one field to export"
      return redirect_to admissions_path
    end

    all_export_columns = (mandatory_columns + selected_fields).uniq

    # Re-use the centralized filter logic
    filter_scope = apply_filters(LearnerInfo.includes(:learner_finance))

    csv_string = "\xEF\xBB\xBF" + CSV.generate(headers: true) do |csv|
      csv << all_export_columns.map { |f| f.to_s.humanize }
      filter_scope.find_each do |learner|
        row = all_export_columns.map do |field|
          case field
          when :hub_name
            learner.hub&.name || "No Hub"
          when :hub_country
            learner.hub&.country || "-"
          else
            field_sym = field.to_sym
            if visible_learner_fields.include?(field_sym)
              learner.send(field)
            elsif visible_finance_fields.include?(field_sym)
              learner.learner_finance&.send(field)
            else
              nil
            end
          end
        end
        csv << row
      end
    end

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

  def check_onboarding_status
    # Ensure user has permission to view/update this learner
    head :forbidden and return unless @permission.show?

    service = OnboardingEmailService.new(@learner_info)
    render json: service.check_readiness
  end

  def send_onboarding_email
    # Ensure user has permission
    head :forbidden and return unless @permission.update?

    service = OnboardingEmailService.new(@learner_info)

    begin
      service.perform_delivery!
      redirect_to admission_path(@learner_info), notice: 'Onboarding email sent successfully.'
    rescue StandardError => e
      Rails.logger.error "Onboarding Email Error: #{e.message}"
      redirect_to admission_path(@learner_info), alert: "Failed to send email: #{e.message}"
    end
  end

  private

  def apply_filters(scope)
    # LC Permission Scope
    if current_user.lc?
      lc_hub_ids = current_user.users_hubs.pluck(:hub_id)
      if lc_hub_ids.any?
        scope = scope.where(
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
        scope = scope.where(learning_coach_id: current_user.id)
      end
    end

    # Advanced Search: Split words and ensure ALL words match somewhere in the record
    if params[:search].present?
      search_terms = params[:search].strip.split(/\s+/)
      search_terms.each do |term|
        term_pattern = "%#{term}%"
        scope = scope.where(
          "full_name ILIKE :pattern OR " \
          "personal_email ILIKE :pattern OR institutional_email ILIKE :pattern OR " \
          "parent1_full_name ILIKE :pattern OR parent1_email ILIKE :pattern OR " \
          "parent2_full_name ILIKE :pattern OR parent2_email ILIKE :pattern",
          pattern: term_pattern
        )
      end
    end

    # Multi-select filters
    if params[:status].present?
      statuses = Array(params[:status]).reject(&:blank?)
      scope = scope.where(status: statuses) if statuses.any?
    end

    if params[:curriculum].present?
      curricula = Array(params[:curriculum]).reject(&:blank?)
      scope = scope.where(curriculum_course_option: curricula) if curricula.any?
    end

    if params[:grade_year].present?
      grades = Array(params[:grade_year]).reject(&:blank?)
      scope = scope.where(grade_year: grades) if grades.any?
    end

    if params[:programme].present?
      programmes = Array(params[:programme]).reject(&:blank?)
      scope = scope.where(programme: programmes) if programmes.any?
    end

    # Complex Hub Filtering
    if params[:hub].present?
      hub_names = Array(params[:hub]).reject(&:blank?)
      if hub_names.any?
        hubs = Hub.where(name: hub_names)
        if hubs.any?
          hub_ids = hubs.pluck(:id)
          scope = scope.where(
            "(learner_infos.hub_id IN (:hub_ids)) OR " \
            "(learner_infos.hub_id IS NULL AND EXISTS (" \
              "SELECT 1 FROM users_hubs uh " \
              "WHERE uh.user_id = learner_infos.user_id " \
              "AND uh.hub_id IN (:hub_ids) " \
              "AND uh.main = TRUE" \
            "))",
            hub_ids: hub_ids
          )
        else
          scope = scope.where("1 = 0")
        end
      end
    end

    # Age Range
    if params[:age_min].present? || params[:age_max].present?
      current_min = params[:age_min].presence&.to_i || 0
      current_max = params[:age_max].presence&.to_i || 100
      scope = scope.where(
        "EXTRACT(YEAR FROM AGE(birthdate)) BETWEEN ? AND ?",
        current_min,
        current_max
      )
    end

    scope
  end

  def require_staff
    redirect_to root_path unless current_user&.staff?
  end

  def set_learner_info
    @learner_info = LearnerInfo.includes(:user).find(params[:id])
    @permission   = LearnerInfoPermission.new(current_user, @learner_info)
  end

  def set_learning_coaches
    # Get all LCs who can teach remote
    @remote_lcs = User.joins(:collaborator_info)
                            .where(deactivate: false)
                            .where(collaborator_infos: { can_teach_remote: true })
                            .includes(:users_hubs)

    @remote_lcs = @remote_lcs.map do |lc|
      # Find the main hub for this lc
      main_users_hub = lc.users_hubs.find_by(main: true)
      main_hub = main_users_hub&.hub
      next unless main_hub

      # Use hub model methods
      lc_count = main_hub.learning_coaches.to_a.count
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
