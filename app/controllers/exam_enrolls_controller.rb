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

    @exam_enrolls = ExamEnroll.includes(:moodle_timeline)
                             .where('moodle_timelines.start_date BETWEEN ? AND ?', @sprint.start_date, @sprint.end_date)
                             .order('moodle_timelines.start_date ASC')
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

    # Add current LC to lc_ids if not already present
    if current_user.role == 'lc' && !@exam_enroll.lc_ids.include?(current_user.id)
      @exam_enroll.lc_ids = (@exam_enroll.lc_ids + [current_user.id]).uniq
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
    # Add current LC to lc_ids if not already present
    if current_user.role == 'lc' && !@exam_enroll.lc_ids.include?(current_user.id)
      @exam_enroll.lc_ids = (@exam_enroll.lc_ids + [current_user.id]).uniq
    end

    if @exam_enroll.update(exam_enroll_params)
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
      redirect_to @exam_enroll, notice: 'Exam enrollment was successfully updated.'
    else
      @moodle_timelines = MoodleTimeline.all
      render :edit
    end
  end

  def destroy
    @exam_enroll.destroy
    redirect_to exam_enrolls_path, notice: 'Exam enrollment was successfully deleted.'
  end

  def remove_lc
    @exam_enroll = ExamEnroll.find(params[:id])
    lc_id = params[:lc_id].to_i

    if @exam_enroll.lc_ids.include?(lc_id)
      @exam_enroll.lc_ids = @exam_enroll.lc_ids - [lc_id]

      if @exam_enroll.save
        render json: { success: true }
      else
        render json: { success: false, error: 'Failed to remove Learning Coach' }
      end
    else
      render json: { success: false, error: 'Learning Coach not found in exam enrollment' }
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
      :learning_coach,
      :learning_coach_email,
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
      :exception_justification,
      :exception_cm_approval,
      :exception_cm_comment,
      :exception_edu_approval,
      :exception_edu_comment,
      :exception_dc_approval,
      :exception_dc_comment,
      :specific_papers,
      documents: [],
      document_description: []
    )
  end
end
