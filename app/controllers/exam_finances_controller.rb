class ExamFinancesController < ApplicationController
  before_action :set_exam_finance, only: [:show, :edit, :update, :destroy, :generate_statement, :preview_statement]

  def index
    # Load exam finances for learners with Nov 2025 enrollments
    exam_finances = ExamFinance.includes(user: { users_hubs: :hub })
                              .joins(:user)
                              .where(exam_season: "November 2025")
                              .order('users.full_name ASC')

    # Filter to only those with matching exam enrollments
    @exam_finances = exam_finances.select do |finance|
      ExamEnroll.joins(:timeline)
                .where(timelines: { user_id: finance.user_id })
                .any? { |enroll| enroll.display_exam_date == finance.exam_season }
    end
  end

  def show
    @exam_enrolls = ExamEnroll.joins(:timeline)
                             .includes(:timeline)
                             .where(timelines: { user_id: @exam_finance.user_id })
                             .select { |enroll| enroll.display_exam_date == @exam_finance.exam_season }
                             .sort_by(&:subject_name)
  end

  def new
    @exam_finance = ExamFinance.new
  end

  def edit
  end

  def create
    @exam_finance = ExamFinance.new(exam_finance_params)

    if @exam_finance.save
      redirect_to @exam_finance, notice: 'Exam finance was successfully created.'
    else
      render :new
    end
  end

  def update
    respond_to do |format|
      if @exam_finance.update(exam_finance_params)
        format.html { redirect_to preview_statement_exam_finance_path(@exam_finance), notice: 'Exam finance was successfully updated.' }
        format.json { render json: { status: 'success' } }
      else
        format.html { render :edit }
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
                             .sort_by(&:subject_name)
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

    # Total Cost Section
    pdf.text "Total Cost: #{(@exam_finance.total_cost)}€", size: 14, style: :bold
    pdf.move_down 20

    # Comments Section (if present)
    if @exam_finance.comments.present?
      pdf.text "Additional Comments:", size: 12, style: :bold
      pdf.move_down 5
      pdf.text @exam_finance.comments, size: 12
      pdf.move_down 20
    end

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
    params.require(:exam_finance).permit(:user_id, :total_cost, :status, :comments)
  end
end
