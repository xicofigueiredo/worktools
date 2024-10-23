class NotesController < ApplicationController
  before_action :set_learner, only: %i[new create edit update destroy]

  def index
    @notes = Note.all
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
end
