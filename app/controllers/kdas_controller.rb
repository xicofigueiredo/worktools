class KdasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_kda, only: [:show, :edit, :update, :destroy]
  before_action :set_questions, only: [:new, :show, :edit, :create, :update]
  before_action :set_weeks, only: [:new, :edit, :create, :update]
  before_action :set_available_weeks, only: [:new, :edit, :create, :update]

  # GET /kdas
  def index
    @kdas = current_user.kdas.includes(:week).order('weeks.start_date DESC')
  end

  # GET /kdas/1
  def show
  end

  # GET /kdas/new
  def new
    @kda = Kda.new
    @kda.user_id = current_user.id
    @questions.each do |question|
      kdas_question = @kda.kdas_questions.build(question: question)
      ['sdl', 'ini', 'mot', 'p2p', 'hubp'].each do |type|
        kdas_question.answers.build(answer_type: type)
      end
    end
  end

  # GET /kdas/1/edit
  def edit
  end

  # POST /kdas
  def create
    processed_params = process_kda_params(kda_params)
    @kda = current_user.kdas.build(processed_params)

    if @kda.save
      redirect_to kdas_path, notice: 'Kda was successfully created.'
    else
      set_weeks # Ensures @weeks is set for the form
      flash.now[:alert] = 'KDA could not be created. Please check your input.'
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /kdas/1
  def update
    if @kda.update(kda_params)
      redirect_to kda_path(@kda), notice: 'Kda was successfully updated.'
    else
      set_weeks # Make sure @weeks is set for the form to render correctly
      flash.now[:alert] =  'KDA could not be updated. Please check your input.'
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /kdas/1
  def destroy
    @kda.destroy
    redirect_to kdas_url, notice: 'Kda was successfully destroyed.'
  end

  private

    def process_kda_params(params)
      params[:kdas_questions_attributes].each do |_, question_attributes|
        question_id = question_attributes[:question_id]
        question_attributes[:answers_attributes].each do |_, answer_attributes|
          answer_attributes[:question_id] = question_id
        end
      end
      params
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_kda
      @kda = Kda.find(params[:id])
    end

    def set_weeks
      @weeks = Week.all.order(:start_date)
    end

    def kda_params
      params.require(:kda).permit(:week_id, kdas_questions_attributes: [:question_id, answers_attributes: [:value, :answer_type]])
    end

    def set_questions
      @questions = Question.where(kda: true).order(:created_at)
    end

    def set_available_weeks
      used_week_ids = current_user.kdas.pluck(:week_id)
      @available_weeks = Week.where.not(id: used_week_ids)
    end
end
