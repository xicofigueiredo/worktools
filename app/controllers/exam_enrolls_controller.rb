class ExamEnrollsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_exam_enroll, only: [:show, :edit, :update, :destroy]

  def index
    # Get the target sprint based on date parameter or default to current sprint
    if params[:date].present?
      target_date = Date.parse(params[:date])
      @sprint = Sprint.where("start_date <= ? AND end_date >= ?", target_date, target_date).first
    end

    # Fallback to current sprint if no sprint found
    @sprint ||= Sprint.where("start_date <= ? AND end_date >= ?", Date.today, Date.today).first

    # Get adjacent sprints for navigation
    @previous_sprint = Sprint.where("end_date < ?", @sprint.start_date).order(end_date: :desc).first
    @next_sprint = Sprint.where("start_date > ?", @sprint.end_date).order(start_date: :asc).first

    @exam_enrolls = ExamEnroll.all

    # Get all unique statuses, hubs, and subjects for the filter dropdowns
    @available_statuses = ExamEnroll.distinct.pluck(:status).compact.sort
    @available_hubs = ExamEnroll.distinct.pluck(:hub).compact.sort
    @available_subjects = ExamEnroll.distinct.pluck(:subject_name).compact.sort

    # Add these lines for filtering (before the role-based logic)
    status_filter = params[:status] || 'all'
    hub_filter = params[:hub] || 'all'
    subject_filter = params[:subject] || 'all'

    # Apply status filter
    if status_filter != 'all'
      @exam_enrolls = @exam_enrolls.where(status: status_filter)
    end

    # Apply hub filter
    if hub_filter != 'all'
      @exam_enrolls = @exam_enrolls.where(hub: hub_filter)
    end

    # Apply subject filter
    if subject_filter != 'all'
      @exam_enrolls = @exam_enrolls.where(subject_name: subject_filter)
    end

    # Store current filters
    @current_status = status_filter
    @current_hub = hub_filter
    @current_subject = subject_filter

    # Role-based filtering (updated logic to handle both exam_date and personalized_exam_date)
    if current_user.role == 'real lc' #future lc logic
      # Debug: Check current user's main hub
      main_hub = current_user.users_hubs.find_by(main: true)

      # Get users who belong to the same main hub as current user
      main_hub_user_ids = User.joins(:users_hubs)
                              .where(users_hubs: {
                                hub_id: main_hub&.hub_id,
                                main: true
                              })
                              .pluck(:id)

      # Get hub names instead of hub objects
      current_user_hub_names = current_user.users_hubs.map(&:hub).map(&:name)

      # Filter by exam enrolls that have either:
      # 1. A timeline with exam_date in the sprint range, OR
      # 2. A personalized_exam_date in the sprint range
      @exam_enrolls = @exam_enrolls.includes(timeline: [:exam_date, :user])
        .left_joins(timeline: [:exam_date, :user])
        .where(
          '(exam_dates.date BETWEEN ? AND ?) OR (exam_enrolls.personalized_exam_date BETWEEN ? AND ?)',
          @sprint.start_date, @sprint.end_date,
          @sprint.start_date, @sprint.end_date
        )
        .where('exam_enrolls.hub IN (?)', current_user_hub_names)
        .where('timelines.user_id IN (?) OR timelines.user_id IS NULL', main_hub_user_ids)
        .order('users.full_name ASC')

    elsif current_user.role == 'lc' #dc logic
      # Get all hub IDs where the DC is assigned
      dc_hub_ids = current_user.users_hubs.pluck(:hub_id)

      # Get users who belong to any of the DC's hubs (with main = true)
      dc_hub_user_ids = User.joins(:users_hubs)
      .where("users.deactivate IS NULL OR users.deactivate = ?", false)
      .where(users_hubs: {
        hub_id: dc_hub_ids,
        main: true
      })
      .pluck(:id)

      # Get hub names for filtering exam enrolls
      dc_hub_names = Hub.where(id: dc_hub_ids).pluck(:name)

      @exam_enrolls = @exam_enrolls.includes(timeline: [:exam_date, :user])
      .left_joins(timeline: [:exam_date, :user])
      .where.not(users: { deactivate: true })
      .where(
        '(exam_dates.date BETWEEN ? AND ?) OR (exam_enrolls.personalized_exam_date BETWEEN ? AND ?)',
        @sprint.start_date, @sprint.end_date,
        @sprint.start_date, @sprint.end_date
      )
      .where('exam_enrolls.hub IN (?)', dc_hub_names)
      .where('timelines.user_id IN (?) OR timelines.user_id IS NULL', dc_hub_user_ids)
      .order('users.full_name ASC')

    elsif current_user.role == 'cm'
      @exam_enrolls = @exam_enrolls.includes(timeline: [:exam_date, :user])
        .left_joins(timeline: [:exam_date, :user])
        .where.not(users: { deactivate: true })
        .where(
          '(exam_dates.date BETWEEN ? AND ?) OR (exam_enrolls.personalized_exam_date BETWEEN ? AND ?)',
          @sprint.start_date, @sprint.end_date,
          @sprint.start_date, @sprint.end_date
        )
        .where('timelines.subject_id IN (?) OR timelines.subject_id IS NULL', current_user.subjects)
        .order('users.full_name ASC')
    else
      @exam_enrolls = @exam_enrolls.includes(timeline: [:exam_date, :user])
        .left_joins(timeline: [:exam_date, :user])
        .where.not(users: { deactivate: true })
        .where(
          '(exam_dates.date BETWEEN ? AND ?) OR (exam_enrolls.personalized_exam_date BETWEEN ? AND ?)',
          @sprint.start_date, @sprint.end_date,
          @sprint.start_date, @sprint.end_date
        )
        .order('users.full_name ASC')
    end
  end

  def show
    @documents = @exam_enroll.exam_enroll_documents
  end

  def new
    @exam_enroll = ExamEnroll.new

    # If timeline_id is provided, pre-populate the exam enroll
    if params[:timeline_id].present?
      timeline = Timeline.find(params[:timeline_id])

      # Verify the current user has access to this timeline's learner
      unless can_access_learner?(timeline.user)
        redirect_to select_learner_exam_enrolls_path, alert: "You don't have permission to access this learner."
        return
      end

      # Pre-populate the exam enroll with timeline data
      @exam_enroll.timeline_id = timeline.id
      @exam_enroll.learner_name = timeline.user.full_name
      @exam_enroll.hub = timeline.user.main_hub&.name
      @exam_enroll.date_of_birth = timeline.user.birthday
      @exam_enroll.learner_id_number = timeline.user.id_number
      @exam_enroll.gender = timeline.user.gender
      @exam_enroll.native_language_english = timeline.user.native_language_english
      @exam_enroll.progress_cut_off = timeline.progress

      # Only pre-populate subject fields for non-LC users
      # LCs should be able to edit these fields for new registrations
      unless current_user.role == 'lc'
        @exam_enroll.subject_name = timeline.subject.name
        @exam_enroll.code = timeline.subject.code
        @exam_enroll.qualification = timeline.subject.qualification
        @exam_enroll.exam_board = timeline.subject.board
      end

      # Set personalized exam date if provided
      if params[:personalized_exam_date].present?
        @exam_enroll.personalized_exam_date = Date.parse(params[:personalized_exam_date])
      end

      # Set learning coach IDs based on the learner's main hub
      if timeline.user.main_hub
        lcs = timeline.user.main_hub.users.where(role: 'lc', deactivate: false)
                      .reject { |lc| lc.hubs.count >= 3 }
        @exam_enroll.learning_coach_ids = lcs.map(&:id)
      end
    end

    @moodle_timelines = current_user.moodle_timelines.all.map { |mt| [mt.subject.name, mt.id] }
  end

  def select_learner
    # Get learners from the current user's hubs
    if current_user.role == 'admin'
      current_user_hub_ids = current_user.users_hubs.pluck(:hub_id)
      @learners = User.joins(:users_hubs)
                      .where(role: 'learner', deactivate: [false, nil])
                      .where(users_hubs: { hub_id: current_user_hub_ids, main: true })
                      .includes(:users_hubs, :hubs)
                      .order(:full_name)
                      .distinct
    elsif current_user.role == 'lc'
      # Get learners from ALL hubs that the current LC belongs to
      current_user_hub_ids = current_user.users_hubs.pluck(:hub_id)
      @learners = User.joins(:users_hubs)
                      .where(role: 'learner', deactivate: [false, nil])
                      .where(users_hubs: { hub_id: current_user_hub_ids, main: true })
                      .includes(:users_hubs, :hubs)
                      .order(:full_name)
                      .distinct
    elsif current_user.role == 'cm'
      # Get learners from subjects the CM manages
      @learners = User.joins(:timelines)
                      .where(timelines: { subject_id: current_user.subjects })
                      .where(role: 'learner', deactivate: [false, nil])
                      .includes(:users_hubs, :hubs)
                      .order(:full_name)
                      .distinct
    else
      @learners = []
    end
  end

  def select_timeline
    @learner = User.find(params[:learner_id])

    # Verify the current user has access to this learner
    unless can_access_learner?(@learner)
      redirect_to select_learner_exam_enrolls_path, alert: "You don't have permission to access this learner."
      return
    end

    # Get timelines for the selected learner that DON'T have exam dates
    # and DON'T already have an exam enroll
    existing_exam_enroll_timeline_ids = ExamEnroll.where.not(timeline_id: nil).pluck(:timeline_id)

    @timelines = @learner.timelines.includes(:subject)
                        .where(exam_date_id: nil)  # No exam date set
                        .where(hidden: false)
                        .where.not(id: existing_exam_enroll_timeline_ids)  # No existing exam enroll
                        .order(:start_date)
  end

  def select_exam_date
    @timeline = Timeline.find(params[:timeline_id])
    @learner = @timeline.user

    # Verify the current user has access to this learner
    unless can_access_learner?(@learner)
      redirect_to select_learner_exam_enrolls_path, alert: "You don't have permission to access this learner."
      return
    end

    # Check if this timeline already has an exam enroll
    if ExamEnroll.exists?(timeline_id: @timeline.id)
      redirect_to select_timeline_exam_enrolls_path(learner_id: @learner.id),
                  alert: "This timeline already has an exam enrollment."
      return
    end
  end

  def edit
    @moodle_timelines = current_user.moodle_timelines.all.map { |mt| [mt.subject.name, mt.id] }
  end

  def create
    @exam_enroll = ExamEnroll.new(exam_enroll_params)

    # Add current LC to learning_coach_ids if not already present
    if current_user.role == 'lc' && !@exam_enroll.learning_coach_ids.include?(current_user.id)
      @exam_enroll.learning_coach_ids = (@exam_enroll.learning_coach_ids + [current_user.id]).uniq
    end

    # Check for progress cut-off warning
    if current_user.role == 'admin' && @exam_enroll.progress_cut_off == false
      flash.now[:warning] = "⚠️ Progress cut-off is not met. Please verify the learner's progress or proceed with an exception request in the form below."
    end

    if @exam_enroll.save
      # Handle document uploads
      if params[:exam_enroll][:documents].present?
        upload_errors = []
        params[:exam_enroll][:documents].each do |doc|
          next if doc.blank? || doc.is_a?(String)

          begin
            document = @exam_enroll.exam_enroll_documents.create!(
              file_name: doc.original_filename,
              description: params[:exam_enroll][:document_description]
            )
            document.file.attach(doc)

            unless document.valid?
              document.destroy
              upload_errors << "#{doc.original_filename}: #{document.errors.full_messages.join(', ')}"
            end
          rescue => e
            upload_errors << "#{doc.original_filename}: #{e.message}"
          end
        end

        if upload_errors.any?
          flash[:alert] = "Some files could not be uploaded: #{upload_errors.join('; ')}"
        end
      end

      redirect_to @exam_enroll, notice: 'Exam enrollment was successfully created.'
    else
      @moodle_timelines = MoodleTimeline.all
      render :new
    end
  end

  def update
    # Check for progress cut-off warning BEFORE updating
    show_warning = current_user.role == 'admin' && (exam_enroll_params[:progress_cut_off] == '0' || exam_enroll_params[:mock_results] == 'U' || exam_enroll_params[:mock_results] == '0')

    respond_to do |format|
      if @exam_enroll.update(exam_enroll_params)
        # Handle document uploads
        if params[:exam_enroll][:documents].present?
          upload_errors = []
          params[:exam_enroll][:documents].each do |doc|
            next if doc.blank? || doc.is_a?(String)

            begin
              document = @exam_enroll.exam_enroll_documents.create!(
                file_name: doc.original_filename,
                description: params[:exam_enroll][:document_description]
              )
              document.file.attach(doc)

              unless document.valid?
                document.destroy
                upload_errors << "#{doc.original_filename}: #{document.errors.full_messages.join(', ')}"
              end
            rescue => e
              upload_errors << "#{doc.original_filename}: #{e.message}"
            end
          end

          if upload_errors.any?
            flash[:alert] = "Some files could not be uploaded: #{upload_errors.join('; ')}"
          end
        end



        # Add warning message if needed
        if show_warning
          if !exam_enroll_params[:progress_cut_off]
            flash[:warning] = "⚠️ WARNING: Progress cut-off is not met! Please verify the learner's progress or consider submitting an exception request."
          elsif (exam_enroll_params[:mock_results] == 'U' || exam_enroll_params[:mock_results] == '0') && exam_enroll_params[:failed_mock_exception_justification] == ""
            flash[:warning] = "⚠️ WARNING: Mock results are not met! Please verify the learner's mock results or consider submitting an failed mock exception request."
          end
        end

        format.html { redirect_to @exam_enroll }
        format.json { render :show, status: :ok, location: @exam_enroll }
      else
        @moodle_timelines = current_user.moodle_timelines.all.map { |mt| [mt.subject.name, mt.id] }
        format.html { render :edit }
        format.json { render json: @exam_enroll.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @exam_enroll.destroy
    redirect_to exam_enrolls_path, notice: 'Exam enrollment was successfully deleted.'
  end

  def remove_lc
    @exam_enroll = ExamEnroll.find(params[:id])
    lc_id = params[:lc_id].to_i

    if @exam_enroll.learning_coach_ids.include?(lc_id)
      @exam_enroll.learning_coach_ids = @exam_enroll.learning_coach_ids - [lc_id]

      if @exam_enroll.save
        render json: { success: true }
      else
        render json: { success: false, error: 'Failed to remove Learning Coach' }
      end
    else
      render json: { success: false, error: 'Learning Coach not found in exam enrollment' }
    end
  end

  def download_document
    @exam_enroll = ExamEnroll.find(params[:id])
    document = @exam_enroll.exam_enroll_documents.find(params[:document_id])

    if document.file.attached?
      disposition = params[:download] == 'true' ? 'attachment' : 'inline'
      redirect_to rails_blob_path(document.file, disposition: disposition)
    else
      redirect_to @exam_enroll, alert: 'File not found.'
    end
  end

  def delete_document
    @exam_enroll = ExamEnroll.find(params[:id])
    document = @exam_enroll.exam_enroll_documents.find(params[:document_id])

    if document.file.attached?
      document.file.purge
    end
    document.destroy

    respond_to do |format|
      format.html { redirect_to edit_exam_enroll_path(@exam_enroll), notice: 'Document was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  def set_exam_enroll
    @exam_enroll = ExamEnroll.find(params[:id])
  end

  def can_access_learner?(learner)
    current_user == learner ||
    current_user.role == 'admin' ||
    (current_user.role.in?(['lc', 'cm']) && (current_user.hubs & learner.hubs).present?)
  end

  def exam_enroll_params
    params.require(:exam_enroll).permit(
      :timeline_id,
      :personalized_exam_date,
      :moodle_timeline_id,
      :hub,
      :learner_name,
      :learner_id_type,
      :learner_id_number,
      :date_of_birth,
      :gender,
      :native_language_english,
      :subject_name,
      :code,
      :qualification,
      :progress_cut_off,
      :mock_results,
      :specific_papers,
      :bga_exam_centre,
      :exam_board,
      :has_special_accommodations,
      :special_accommodations_personalized,
      :additional_comments,
      :extension_justification,
      :extension_cm_approval,
      :extension_cm_comment,
      :extension_edu_approval,
      :extension_edu_comment,
      :extension_dc_approval,
      :extension_dc_comment,
      :pre_registration_exception_justification,
      :pre_registration_exception_cm_approval,
      :pre_registration_exception_cm_comment,
      :pre_registration_exception_dc_approval,
      :pre_registration_exception_dc_comment,
      :pre_registration_exception_edu_approval,
      :pre_registration_exception_edu_comment,
      :failed_mock_exception_justification,
      :failed_mock_exception_cm_approval,
      :failed_mock_exception_cm_comment,
      :failed_mock_exception_dc_approval,
      :failed_mock_exception_dc_comment,
      :failed_mock_exception_edu_approval,
      :failed_mock_exception_edu_comment,
      :repeating,
      :graduating,
      learning_coach_ids: []
    )
  end
end
