class NewslettersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!, except: [:index]
  before_action :set_newsletter, only: [:edit, :update, :destroy, :show]

  def index
    @newsletters = Newsletter.all.order(created_at: :desc)
  end

  def show
  end

  def new
    @newsletter = Newsletter.new
  end

  def create
    @newsletter = Newsletter.new(newsletter_params)
    if @newsletter.save
      redirect_to newsletters_path, notice: 'Newsletter created successfully.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @newsletter.update(newsletter_params)
      redirect_to newsletters_path, notice: 'Newsletter updated successfully.'
    else
      render :edit
    end
  end

  private

  def set_newsletter
    @newsletter = Newsletter.find(params[:id])
  end

  def newsletter_params
    params.require(:newsletter).permit(:title, :content, :published_at,
                                       :filter_country, :filter_role,
                                       :filter_level, :filter_region)
  end

  # Replace this logic with what fits your application.
  def authorize_admin!
    unless current_user.role == 'admin' || current_user.email == "francisco-abf@hotmail.com"
      redirect_to newsletters_path, alert: 'You are not authorized to perform this action.'
    end
  end
end
