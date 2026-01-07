class NotesController < ApplicationController
  before_action :set_learner, only: %i[index new create edit update destroy summarize summaries]
  before_action :enforce_category_for_cm, only: [:create, :update]


  def index
    @notes = @learner.notes.includes(:written_by).order(date: :desc)
    @notes_by_month = @notes.group_by { |note| note.date.beginning_of_month }
  end

  def show
  end

  def new
    @note = Note.new
  end

  def edit
    @learner = User.find(params[:user_id])
    @note = @learner.notes.find(params[:id])
  end

  def create
    @note = @learner.notes.build(note_params)
    @note.date = Date.today
    @note.status = 'Not Done'
    @note.written_by_id = current_user.id

    respond_to do |format|
      if @note.save
        format.html { redirect_to learner_profile_path(@learner), notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @learner = User.find(params[:user_id])
    @note = @learner.notes.find(params[:id])
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to learner_profile_path(@learner), notice: "Note was successfully updated." }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @learner = User.find(params[:user_id])
    @note = @learner.notes.find(params[:id])
    @note.destroy

    respond_to do |format|
      format.html { redirect_to learner_profile_path(@learner), notice: "Note was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def summarize
    @notes = @learner.notes.order(date: :desc)

    # If no date params, just show the form
    unless params[:start_date].present? && params[:end_date].present?
      @start_date = @notes.minimum(:date) || Date.today
      @end_date = Date.today
      @summary_result = nil

      respond_to do |format|
        format.html { render :summarize, layout: false }
        format.json { render json: { form_only: true } }
      end
      return
    end

    # Get date range from params
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    # Filter notes by date range
    notes_to_summarize = @notes.where(date: start_date..end_date)

    # Check if user wants to regenerate (ignore saved summary)
    regenerate = params[:regenerate].present?

    # Check if it's a weekly summary request
    if params[:weekly].present?
      week_start = params[:week_start] ? Date.parse(params[:week_start]) : Date.today.beginning_of_week
      week_end = params[:week_end] ? Date.parse(params[:week_end]) : Date.today.end_of_week

      service = NoteSummarizationService.new(notes_to_summarize, learner: @learner, start_date: week_start, end_date: week_end)
      @summary_result = service.weekly_summary(
        week_start: week_start,
        week_end: week_end,
        save_as_summary: !regenerate
      )
    else
      # Regular summary with date range
      service = NoteSummarizationService.new(notes_to_summarize, learner: @learner, start_date: start_date, end_date: end_date)
      @summary_result = service.summarize(save_as_summary: !regenerate)
    end

    @start_date = start_date
    @end_date = end_date

    respond_to do |format|
      format.html { render :summarize, layout: false }
      format.json { render json: @summary_result }
    end
  end

  def summaries
    @learner = User.find(params[:user_id])
    @summaries = @learner.ai_summaries.recent
  end

  private

  def set_learner
    @learner = User.find(params[:user_id])
  end

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:category, :topic, :follow_up_action, :status)
  end

  def enforce_category_for_cm
    if current_user.role == "cm"
      params[:note][:category] = "knowledge"
    end
  end
end
