class ExamFinancesController < ApplicationController
  before_action :set_exam_finance, only: [:show, :edit, :update, :destroy, :generate_statement, :preview_statement]

  def index
    # Get the target season based on date parameter or default to current season
    if params[:date].present?
      target_date = Date.parse(params[:date])
      @season = Sprint.find_season_for_date(target_date)
    else
      @season = Sprint.current_season
    end

    # Get adjacent seasons for navigation
    @previous_season = Sprint.previous_season(@season)
    @next_season = Sprint.next_season(@season)

    # Get the exam_season values that match this season (e.g., ["May 2026", "June 2026"] for May/June)
    season_matches = Sprint.exam_season_matches(@season)

    # Get all unique finance_statuses from exam enrollments for the filter dropdown
    @available_statuses = ExamEnroll.distinct.pluck(:finance_status).compact.sort

    # Get filter parameters with role-based defaults
    status_filter = params[:status]
    is_default_filter = status_filter.blank?

    # Apply role-based default filters if no status is explicitly provided
    if status_filter.blank?
      if current_user.role == 'exams'
        status_filter = 'No Status'
      elsif current_user.role == 'finance'
        status_filter = 'Sent to Finance'
      else
        status_filter = 'all'
      end
    end

    # Load exam finances for the selected season with eager loading
    exam_finances = ExamFinance.includes(user: [:main_hub, :users_hubs])
                              .joins(:user)
                              .where(exam_season: season_matches)
                              .order('users.full_name ASC')

    # Get all user_ids for the exam finances
    user_ids = exam_finances.pluck(:user_id).uniq

    # Load ALL exam enrolls for these users in ONE query with proper eager loading
    all_enrolls = ExamEnroll.left_joins(timeline: :exam_date)
                          .includes(timeline: [:exam_date, :user])
                          .where(timelines: { user_id: user_ids })
                          .to_a # Load into memory once

    # Group enrolls by user_id and exam_season for fast lookup
    enrolls_by_user_and_season = {}
    all_enrolls.each do |enroll|
      exam_season = enroll.display_exam_date
      next if exam_season.blank? || exam_season == "No exam date set"

      user_id = enroll.timeline&.user_id
      next unless user_id

      key = [user_id, exam_season]
      enrolls_by_user_and_season[key] ||= []
      enrolls_by_user_and_season[key] << enroll
    end

    # Filter finances to only those with matching enrollments
    exam_finances_with_enrolls = exam_finances.select do |finance|
      enrolls_by_user_and_season[[finance.user_id, finance.exam_season]].present?
    end

    # Preload exam enrolls for each finance
    @exam_enrolls_by_finance = {}
    exam_finances_with_enrolls.each do |finance|
      enrolls = enrolls_by_user_and_season[[finance.user_id, finance.exam_season]] || []
      @exam_enrolls_by_finance[finance.id] = enrolls.sort_by { |enroll| enroll.subject_name.to_s.downcase }
    end

    # Apply status filter based on exam_enroll.finance_status
    if status_filter != 'all'
      @exam_finances = exam_finances_with_enrolls.select do |finance|
        enrolls = @exam_enrolls_by_finance[finance.id] || []
        enrolls.any? { |enroll| enroll.respond_to?(:finance_status) && enroll.finance_status == status_filter }
      end
    else
      @exam_finances = exam_finances_with_enrolls
    end

    # If default filter was applied but no results found, fall back to 'all'
    if is_default_filter && @exam_finances.empty? && status_filter != 'all'
      # Redirect to update URL with 'all' status
      redirect_to exam_finances_path(status: 'all', date: params[:date])
      return
    end

    # Store current filter
    @current_status = status_filter
  end

  def show
    @exam_enrolls = ExamEnroll.joins(:timeline)
                             .includes(:timeline)
                             .where(timelines: { user_id: @exam_finance.user_id })
                             .select { |enroll| enroll.display_exam_date == @exam_finance.exam_season }
                             .sort_by { |enroll| enroll.subject_name.to_s.downcase }

    @exam_finance.update_number_of_subjects(@exam_enrolls.count)

  end

  def new
    @exam_finance = ExamFinance.new
  end

  def edit
  end

  def create
    @exam_finance = ExamFinance.new(exam_finance_params)
    @exam_finance.changed_by_user_email = current_user.email if current_user

    if @exam_finance.save
      redirect_to @exam_finance, notice: 'Exam finance was successfully created.'
    else
      render :new
    end
  end

  def update
    @exam_finance.changed_by_user_email = current_user.email if current_user
    respond_to do |format|
      if @exam_finance.update(exam_finance_params)
        format.html {
          if request.xhr?
            head :ok
          else
            if request.referer&.include?('preview_statement')
              redirect_to preview_statement_exam_finance_path(@exam_finance), notice: 'Exam finance was successfully updated.'
            else
              redirect_to @exam_finance, notice: 'Exam finance was successfully updated.'
            end
          end
        }
        format.json { render json: { status: 'success' } }
      else
        format.html {
          if request.xhr?
            render json: @exam_finance.errors, status: :unprocessable_entity
          else
            render :edit
          end
        }
        format.json { render json: @exam_finance.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @exam_finance.destroy
    redirect_to exam_finances_url, notice: 'Exam finance was successfully destroyed.'
  end

  def preview_statement
    @exam_enrolls = ExamEnroll.joins(:timeline)
                             .includes(:timeline)
                             .where(timelines: { user_id: @exam_finance.user_id })
                             .select { |enroll| enroll.display_exam_date == @exam_finance.exam_season }
                             .sort_by { |enroll| enroll.subject_name.to_s.downcase }
  end

  def generate_statement
    # Get selected enrollment IDs from params
    selected_ids = if params[:selected_enrolls].is_a?(Array)
                    params[:selected_enrolls].map(&:to_i).reject(&:zero?)
                  else
                    params[:selected_enrolls].to_s.split(',').map(&:to_i).reject(&:zero?)
                  end

    @exam_enrolls = ExamEnroll.joins(:timeline)
                             .includes(:timeline)
                             .where(timelines: { user_id: @exam_finance.user_id })
                             .where(id: selected_ids)
                             .order(:subject_name)

    # Calculate total cost for display only, don't save it
    @calculated_total = view_context.calculate_total_cost(@exam_enrolls)

    pdf = Prawn::Document.new

    # Header Section with Logo and Learner Info
    cursor = pdf.cursor

    # Left Section (Learner and Hub Info)
    pdf.bounding_box([0, cursor], width: pdf.bounds.width / 3) do
      pdf.text "#{@exam_finance.user.full_name}", size: 20, style: :bold
      pdf.text "#{@exam_finance.user.hubs.first.name} Hub", size: 12
    end

    # Center Section (Statement Info)
    pdf.bounding_box([pdf.bounds.width / 3, cursor], width: pdf.bounds.width / 3) do
      pdf.text "Internal Statement of Entry", size: 12, style: :bold, align: :center
      pdf.text "Generated on #{Date.today.strftime("%d %B %Y")}", size: 12, align: :center
    end

    # Right Section (Logo)
    pdf.bounding_box([pdf.bounds.width * 2 / 3, cursor], width: pdf.bounds.width / 3) do
      pdf.image Rails.root.join("app/assets/images/logoreport.png"), width: 110, height: 55, position: :right
    end

    # Add a line separating the header from the rest of the PDF
    pdf.move_down 20
    pdf.stroke_color "000000"
    pdf.stroke_line([0, pdf.cursor], [pdf.bounds.width, pdf.cursor])
    pdf.move_down 20

    # Parent Notice Section
    pdf.text "Dear Parents and Guardians,", size: 12
    pdf.move_down 10
    pdf.text "Please review your child's exam entries carefully to ensure all information is correct. If you notice any errors or have questions, do not hesitate to contact Princess Taut at exams@bravegenerationacademy.com.", size: 12
    pdf.move_down 10
    pdf.text "When reaching out, kindly include the student's full name and hub. This will help us respond more efficiently.", size: 12, align: :justify
    pdf.move_down 20

    # Exam Enrollments Table
    if @exam_enrolls.any?
      pdf.text "Exam Enrollments", size: 16, style: :bold
      pdf.move_down 10

      table_data = [["Subject", "Code", "Papers", "Exam Center"]]
      table_data += @exam_enrolls.map do |enroll|
        papers_text = if enroll.specific_papers.present?
          papers = []
          (1..5).each do |i|
            if enroll.send("paper#{i}").present?
              papers << enroll.send("paper#{i}")
            end
          end
          papers.join("\n")
        else
          "N/A"
        end

        [
          enroll.subject_name,
          enroll.code,
          papers_text,
          enroll.bga_exam_centre
        ]
      end

      pdf.table(table_data, header: true, width: pdf.bounds.width) do |table|
        table.row(0).background_color = 'D5F000'
        table.row(0).font_style = :bold
        table.cells.padding = [5, 5, 5, 5]
        table.cells.inline_format = true

        # Set specific column widths
        table.column_widths = {
          0 => pdf.bounds.width * 0.3,  # Subject
          1 => pdf.bounds.width * 0.2,  # Code
          2 => pdf.bounds.width * 0.3,  # Papers
          3 => pdf.bounds.width * 0.2   # Cost
        }
      end
    end

    pdf.move_down 20
    pdf.text @exam_finance.comments, size: 12, align: :justify
    pdf.move_down 20

    # Total Cost Section
    pdf.text "Total Cost: #{(@exam_finance.total_cost)} #{@exam_finance.currency}", size: 14, style: :bold
    pdf.move_down 20

    pdf.text "Kind regards,", size: 12
    pdf.text "Princess Carmela Taut", size: 12
    pdf.text "Exams Officer", size: 12
    pdf.text "Brave Generation", size: 12

    # Footer
    pdf.go_to_page(pdf.page_count)
    pdf.bounding_box([0, 50], width: pdf.bounds.width, height: 50) do
      pdf.stroke_line([0, pdf.cursor], [pdf.bounds.width, pdf.cursor])
      pdf.move_down 10
      pdf.text "www.bravegenerationacademy.com", size: 10, align: :left
    end

    filename = "exam_finance_statement_#{@exam_finance.user.full_name.parameterize}.pdf"
    send_data pdf.render,
              filename: filename,
              type: 'application/pdf',
              disposition: 'inline'
  end

  private

  def set_exam_finance
    @exam_finance = ExamFinance.find(params[:id])
  end

  def exam_finance_params
    params.require(:exam_finance).permit(:user_id, :total_cost, :status, :currency)
  end

end
