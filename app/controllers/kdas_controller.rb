class KdasController < ApplicationController
  before_action :set_kda, only: [:show, :edit, :update, :destroy]

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
  end

  # GET /kdas/1/edit
  def edit
  end

  # POST /kdas
  def create
    @kda = Kda.new(kda_params)

    if @kda.save
      redirect_to @kda, notice: 'Kda was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /kdas/1
  def update
    if @kda.update(kda_params)
      redirect_to @kda, notice: 'Kda was successfully updated.'
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
      params.require(:kda).permit(:user_id, :start_date, :end_date)
    end
end
