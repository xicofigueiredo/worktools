class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy]

  def index
    @subjects = Subject.all
  end

  def show
    @topics = @subject.topics
  end

  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.new(subject_params)

    if @subject.save
      redirect_to @subject, notice: 'Subject was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @subject.update(subject_params)
      redirect_to subjects_path , notice: 'Subject was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @subject.topics.destroy_all
    @subject.timelines.destroy_all
    @subject.destroy
    redirect_to subjects_path, notice: 'Subject was successfully destroyed.'
  end

  def get_topics
    @topics = Subject.find(@subject).topics.pluck(:name, :id)
    render json: @topics
  end



  private
    def set_subject
      @subject = Subject.find(params[:id])
    end

    def subject_params
      params.require(:subject).permit(:name, :category, :exam_dates)
    end
end
