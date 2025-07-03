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

    # Get all unique statuses for the filter dropdown
    @available_statuses = ExamEnroll.distinct.pluck(:status).compact.sort

    # Apply status filter if provided
    if params[:status].present? && params[:status] != 'all'
      @exam_enrolls = @exam_enrolls.where(status: params[:status])
    end

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

      @exam_enrolls = @exam_enrolls.includes(timeline: [:exam_date, :user])
        .joins(timeline: [:exam_date, :user])
        .where('exam_dates.date BETWEEN ? AND ?', @sprint.start_date, @sprint.end_date)

      @exam_enrolls = @exam_enrolls.where('exam_enrolls.hub IN (?)', current_user_hub_names)  # Use hub names


      @exam_enrolls = @exam_enrolls.where('timelines.user_id IN (?)', main_hub_user_ids)
        .order('exam_dates.date ASC')

    elsif current_user.role == 'lc' #dc logic
      # Get all hub IDs where the DC is assigned
      dc_hub_ids = current_user.users_hubs.pluck(:hub_id)

      # Get users who belong to any of the DC's hubs (with main = true)
      dc_hub_user_ids = User.joins(:users_hubs)
      .where(users_hubs: {
        hub_id: dc_hub_ids,
        main: true
      })
      .pluck(:id)

      # Get hub names for filtering exam enrolls
      dc_hub_names = Hub.where(id: dc_hub_ids).pluck(:name)

      @exam_enrolls = @exam_enrolls.includes(timeline: [:exam_date, :user])
      .joins(timeline: [:exam_date, :user])
      .where('exam_dates.date BETWEEN ? AND ?', @sprint.start_date, @sprint.end_date)
      .where('exam_enrolls.hub IN (?)', dc_hub_names)
      .where('timelines.user_id IN (?)', dc_hub_user_ids)
      .order('exam_dates.date ASC')
    else
      @exam_enrolls = @exam_enrolls.includes(timeline: :exam_date)
        .joins(timeline: :exam_date)
        .where('exam_dates.date BETWEEN ? AND ?', @sprint.start_date, @sprint.end_date)
        .order('exam_dates.date ASC')
    end
  end

  def show
    @documents = @exam_enroll.exam_enroll_documents
  end

  def new
    @exam_enroll = ExamEnroll.new
    @moodle_timelines = current_user.moodle_timelines.all.map { |mt| [mt.subject.name, mt.id] }
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

    if @exam_enroll.save
      # Handle document uploads
      if params[:exam_enroll][:documents].present?
        params[:exam_enroll][:documents].each do |doc|
          @exam_enroll.exam_enroll_documents.create!(
            file_name: doc.original_filename,
            file_type: doc.content_type,
            file_path: doc.tempfile.path,
            description: params[:exam_enroll][:document_description]
          )
        end
      end
      redirect_to @exam_enroll, notice: 'Exam enrollment was successfully created.'
    else
      @moodle_timelines = MoodleTimeline.all
      render :new
    end
  end

  def update
    respond_to do |format|
      if @exam_enroll.update(exam_enroll_params)
        # Handle document uploads
        if params[:exam_enroll][:documents].present?
          params[:exam_enroll][:documents].each do |doc|
            next if doc.blank? || doc.is_a?(String) # Skip empty strings
            @exam_enroll.exam_enroll_documents.create!(
              file_name: doc.original_filename,
              file_type: doc.content_type,
              file_path: doc.tempfile.path,
              description: params[:exam_enroll][:document_description]
            )
          end
        end

        message = case @exam_enroll.status
                  when 'rejected'
                    'Enrollment was rejected.'
                  when 'approval_pending'
                    'Pending EDU department approval.'
                  when 'mock_pending'
                    'Approved. Waiting for mock exam.'
                  else
                    'Exam enrollment was successfully updated.'
                  end

        format.html { redirect_to @exam_enroll, notice: message }
        format.json { render :show, status: :ok, location: @exam_enroll }
      else
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

  def delete_document
    @exam_enroll = ExamEnroll.find(params[:id])
    document = @exam_enroll.exam_enroll_documents.find(params[:document_id])
    document.purge

    respond_to do |format|
      format.html { redirect_to edit_exam_enroll_path(@exam_enroll), notice: 'Document was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  def set_exam_enroll
    @exam_enroll = ExamEnroll.find(params[:id])
  end


  def exam_enroll_params
    params.require(:exam_enroll).permit(
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
