class TopicsController < ApplicationController
  before_action :set_subject
  before_action :set_topic, only: %i[show edit update destroy]

  def index
    @topics = @subject.topics
  end

  def show
  end

  def new
    @topic = @subject.topics.new
  end

  def create
    @topic = @subject.topics.new(topic_params)

    if @topic.save
      redirect_to subject_path(@subject), notice: 'Topic was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @topic.update(topic_params)
      redirect_to subject_path(@subject), notice: 'Topic was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @topic.destroy
    redirect_to subject_path(@subject), notice: 'Topic was successfully destroyed.'
  end

  private

  def set_subject
    @subject = Subject.find(params[:subject_id])
  end

  def set_topic
    @topic = @subject.topics.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:name, :grade, :done, :time)
  end
end
