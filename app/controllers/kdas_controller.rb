class KdasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_kda, only: [:show, :edit, :update, :destroy]
  before_action :set_questions, only: [:new, :show, :edit, :create, :update]

  # GET /kdas
  def index
    @kdas = Kda.all
  end

  # GET /kdas/1
  def show
  end

  # GET /kdas/new
  def new
    @kda = Kda.new
    @kda.user_id = current_user.id
    @questions.each do |question|
      @kda.kdas_questions.build(question: question)
    end
  end

  # GET /kdas/1/edit
  def edit
  end

  # POST /kdas
  def create
    @kda = Kda.new(kda_params)

    if @kda.save
      redirect_to kdas, notice: 'Kda was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /kdas/1
  def update
    if @kda.update(kda_params)
      redirect_to kda_path(@kda), notice: 'Kda was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /kdas/1
  def destroy
    @kda.destroy
    redirect_to kdas_url, notice: 'Kda was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kda
      @kda = Kda.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def kda_params
      params.require(:kda).permit(:user_id, :start_date, :end_date, kdas_questions_attributes: [:question_id, :sdl, :ini, :mot, :p2p, :hubp])
    end

    def set_questions
      @questions = Question.where(kda: true)
    end
end
