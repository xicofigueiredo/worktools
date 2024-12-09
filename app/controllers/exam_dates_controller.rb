class ExamDatesController < ApplicationController
  def index
    @exam_dates = ExamDate.all.order(:date)
  end

  def new
    @exam_date = ExamDate.new
    @subjects = Subject.all
    @subjects = Subject.order(:category, :name).reject do |subject|
      subject.category == 'lws7' || subject.category == 'lws8' || subject.category == 'lws9' ||
      subject.category == 'lang' || subject.category == 'other' || subject.category == 'up'
    end
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
    @edit = true
    @exam_date = ExamDate.find(params[:id])
    @subjects = Subject.order(:category, :name).reject do |subject|
      subject.category == 'lws7' || subject.category == 'lws8' || subject.category == 'lws9' ||
      subject.category == 'lang' || subject.category == 'other' || subject.category == 'up'
    end
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

    begin
      @exam_date.destroy
      redirect_to exam_dates_path, notice: 'Exam date was successfully deleted.'
    rescue ActiveRecord::InvalidForeignKey
      redirect_to exam_dates_path, alert: 'Cannot delete this exam date because it is still referenced by one or more timelines.'
    end
  end


  private

  def exam_date_params
    params.require(:exam_date).permit(:name, :date, :subject_id)
  end
end
