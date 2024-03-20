class KdasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_kda, only: [:show, :edit, :update, :destroy, :show]
  before_action :set_weeks, only: [:new, :edit, :create, :update, :show]
  before_action :set_available_weeks, only: [:new, :edit, :create, :update, :show]

  # GET /kdas
  def index
    @kdas = current_user.kdas.includes(:week).order('weeks.start_date DESC')
  end

  # GET /kdas/1
  def show
    @kda = current_user.kdas.find(params[:id])
  end


  # GET /kdas/new
  def new
    @kda = Kda.new
    @kda.user_id = current_user.id
    @kda.build_sdl
    @kda.build_ini
    @kda.build_mot
    @kda.build_p2p
    @kda.build_hubp
  end

  # GET /kdas/1/edit
  def edit
    @@kda = Kda.find(params[:id])
    @available_weeks = Week.all
  end

  # POST /kdas
  def create
    @kda = current_user.kdas.new(kda_params)


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
      redirect_to kdas_path, notice: 'Kda was successfully updated.'
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

    # Use callbacks to share common setup or constraints between actions.
    def set_kda
      @kda = Kda.find(params[:id])
    end

    def set_weeks
      @weeks = Week.all.order(:start_date)
    end

    def kda_params
      params.require(:kda).permit(
                    :week_id, :user_id,
                    sdl_attributes: [:id, :rating, :why, :improve, :_destroy],
                    ini_attributes: [:id, :rating, :why, :improve, :_destroy],
                    mot_attributes: [:id, :rating, :why, :improve, :_destroy],
                    p2p_attributes: [:id, :rating, :why, :improve, :_destroy],
                    hubp_attributes: [:id, :rating, :why, :improve, :_destroy])
    end

    def set_available_weeks
      used_week_ids = current_user.kdas.pluck(:week_id)
      @available_weeks = Week.where.not(id: used_week_ids)
    end
end
