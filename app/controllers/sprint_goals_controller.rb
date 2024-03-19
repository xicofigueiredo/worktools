class SprintGoalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sprint_goals, only: [:show, :edit, :update, :destroy]
  before_action :set_questions, only: [:new, :show, :edit, :create, :update]
  before_action :set_sprint, only: [:new, :edit, :create, :update]
  before_action :set_available_sprints, only: [:new, :edit]

  # GET /sprint_goals
  def index
    @sprint_goals = current_user.sprint_goals.includes(:sprint).order('sprints.start_date DESC')
  end

  # GET /sprint_goals/1
  def show
  end

  # GET /sprint_goals/new
  def new
    @sprint_goal = SprintGoal.new(user_id: current_user.id)
    @questions.each do |question|
      questions_sprint_goal = @sprint_goal.questions_sprint_goals.build(question: question)
      ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16'].each do |type|
        questions_sprint_goal.answers.build(answer_type: type)
      end
    end
  end

  # GET /sprint_goals/1/edit
  def edit
  end

  # POST /sprint_goals
  def create
    processed_params = process_sprint_goal_params(sprint_goal_params)
    @sprint_goal = current_user.sprint_goals.build(processed_params)

    if @sprint_goal.save
      redirect_to sprint_goals_path, notice: 'sprint_goal was successfully created.'
    else
      set_sprint # Ensures @sprints is set for the form
      flash.now[:alert] = 'sprint_goal could not be created. Please check your input.'
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sprint_goals/1
  def update
    if @sprint_goal.update(sprint_goal_params)
      redirect_to sprint_goal_path(@sprint_goal), notice: 'sprint_goal was successfully updated.'
    else
      set_sprint # Make sure @sprints is set for the form to render correctly
      flash.now[:alert] =  'sprint_goal could not be updated. Please check your input.'
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /sprint_goals/1
  def destroy
    @sprint_goal.destroy
    redirect_to sprint_goals_url, notice: 'sprint_goal was successfully destroyed.'
  end

  private

    def process_sprint_goal_params(params)
      params[:questions_sprint_goals_attributes].each do |_, question_attributes|
        question_id = question_attributes[:question_id]
        question_attributes[:answers_attributes].each do |_, answer_attributes|
          answer_attributes[:question_id] = question_id
        end
      end
      params
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_sprint_goals
      @sprint_goal = SprintGoal.find(params[:id])
    end

    def set_sprint
      @sprints = Sprint.all.order(:start_date)
    end

    def sprint_goal_params
      params.require(:sprint_goal).permit(:sprint_id, questions_sprint_goals_attributes: [:question_id, answers_attributes: [:value, :answer_type]])
    end

    def set_questions
      @questions = Question.where(sprint: true).order(:created_at)
    end

    def set_available_sprints
      used_sprints = current_user.sprint_goals.pluck(:sprint_id)
      @available_sprints = Sprint.where.not(id: used_sprints)
    end
end
