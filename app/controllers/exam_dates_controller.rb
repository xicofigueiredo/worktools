class ExamDatesController < ApplicationController
  def index
    @exam_dates = ExamDate.all
  end

  def new
    @exam_date = ExamDate.new
    @subjects = Subject.all
  end

  def create
    @exam_date = ExamDate.new(exam_date_params)
    if @exam_date.save
      redirect_to exam_dates_path
    else
      @subjects = Subject.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @exam_date = ExamDate.find(params[:id])
    @subjects = Subject.all
  end

  def update
    @exam_date = ExamDate.find(params[:id])
    if @exam_date.update(exam_date_params)
      redirect_to exam_dates_path
    else
      @subjects = Subject.all

      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @exam_date = ExamDate.find(params[:id])
    @exam_date.destroy
    redirect_to exam_dates_path
  end

  private

  def exam_date_params
    params.require(:exam_date).permit(:name, :date, :subject_id)
  end
end
