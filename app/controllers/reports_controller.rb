class ReportsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_report, only: %i[edit update toggle_hide update_knowledges update_activities download_pdf destroy_report_knowledge reset_knowledges_from_sprint_goal]

  def lc_view
    redirect_to root_path if current_user.role != 'lc' && current_user.role != 'admin' && current_user.role != 'rm'

    @learners = User.joins(:users_hubs)
    .joins("INNER JOIN hubs ON hubs.id = users_hubs.hub_id")
    .where(hubs: { id: current_user.hubs.ids }, role: 'learner', deactivate: [false, nil])
    .distinct
  end

  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @sprint = Sprint.find_by("start_date <= ? AND end_date >= ?", @date, @date)

    # Check if sprint exists
    if @sprint.nil?
      redirect_to reports_path, alert: "No sprint found for the current date."
      return
    end

    if @sprint && @sprint.id < 12
      redirect_to reports_path, alert: "There are no reports from earlier sprints."
      return
    end

    if current_user.role == 'learner'
      @learner = current_user
    elsif current_user.role == 'guardian'
      @grouped_learners = current_user.kids

      # Determine which learner's report to show
      if params[:learner_id].present?
        @learner = User.find_by(id: params[:learner_id])

        if @learner.nil?
          redirect_to reports_path, alert: "No valid learner found."
          return
        end

        # Ensure the current user has permission to view this learner's report
        unless ((current_user.hubs.ids & @learner.hubs.ids).present? || current_user.online_learners.include?(@learner.id))|| current_user.role == 'admin' || current_user.kids.include?(@learner.id)
          redirect_to reports_path, alert: "You do not have permission to access this report."
            return
        end
      else
        @learner = User.find_by(id: current_user.kids.first)
      end
    else


      hub_learner_ids = User.joins(:users_hubs)
        .joins("INNER JOIN hubs ON hubs.id = users_hubs.hub_id")
        .where(hubs: { id: current_user.hubs.ids }, role: 'learner')
        .where("users.deactivate = ? OR (users.graduated_at BETWEEN ? AND ?)",
               false,
               @sprint.start_date,
               @sprint.end_date)
        .pluck(:id)

      online_learner_ids = current_user.online_learners
        .where("users.deactivate = ? OR (users.graduated_at BETWEEN ? AND ?)",
               false,
               @sprint.start_date,
               @sprint.end_date)
        .pluck(:id)

      all_learner_ids = (hub_learner_ids + online_learner_ids).uniq

      @learners = User.joins("LEFT OUTER JOIN users_hubs ON users_hubs.user_id = users.id")
        .joins("LEFT OUTER JOIN hubs ON hubs.id = users_hubs.hub_id")
        .where(id: all_learner_ids, role: 'learner')
        .select('users.*, COALESCE(MAX(CASE WHEN users_hubs.main = true THEN hubs.name END), MAX(hubs.name), \'Online\') as hub_name')
        .group('users.id')
        .order('hub_name ASC, users.full_name ASC')


      @grouped_learners = @learners.group_by { |learner| learner.hub_name }

      # Determine which learner's report to show
      if params[:learner_id].present?
        @learner = User.find_by(id: params[:learner_id])

        if @learner.nil?
          redirect_to reports_path, alert: "No valid learner found."
          return
        end

        # # Ensure the current user has permission to view this learner's report
        # unless ((current_user.hubs.ids & @learner.hubs.ids).present? || current_user.online_learners.include?(@learner.id)) || current_user.role == 'admin'
        #   redirect_to reports_path, alert: "You do not have permission to access this report."
        #   return
        # end
      else
        @learner = @learners.first
      end
    end

    @timelines = @learner.timelines.where(hidden: false).order(difference: :asc)
    calc_nav_dates(@sprint)
    @report = @learner.reports.find_or_initialize_by(sprint: @sprint, last_update_check: Date.today)

    if @report.new_record?
      @report.last_update_check = Date.today
    end


    @report.save
    @attendance = calc_sprint_presence(@learner, @sprint)

    if @sprint
      @report = @learner.reports.find_by(sprint: @sprint)
    else
      @report = nil
    end

    if @sprint.id <= 12 ## Sprint 12 was the current sprint when reports feature was added
      @has_prev_sprint = false
    else
      @has_prev_sprint = Sprint.exists?(['end_date < ?', @sprint.start_date])
    end
    @has_next_sprint = Sprint.exists?(['start_date > ?', @sprint.end_date])

    # Fetch reports where parent: true for the learner
    @reports_parents = @learner.reports.where(parent: true)

    # Check if the next report belongs to @reports_parents for guardians
    if current_user.role == 'guardian'
      next_sprint = Sprint.where('start_date > ?', @sprint.end_date).first
      if next_sprint
        next_report = @learner.reports.find_by(sprint: next_sprint)
        @disable_next = next_report.nil? || !@reports_parents.include?(next_report)
      else
        @disable_next = true # No next sprint exists
      end
    else
      @disable_next = false
    end

    @edit = false

    if !@report.nil? && @report.user_id == current_user.id
      @hide = @report.hide
    elsif current_user.role == 'guardian'
      @hide = @report.hide
    end

    @report_activities = @report.report_activities

    # Optionally, if you want to ensure the main report is saved
    @report.save
  end

  def new
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @sprint = Sprint.find_by("start_date <= ? AND end_date >= ?", @date, @date)

    @report = current_user.reports.find_or_create_by(sprint: @sprint) do |report|
      report.sprint = @sprint
    end
    redirect_to edit_report_path(@report)
  end

  def edit
    @learner = @report.user

    if !@report.nil? && @learner == current_user
      @hide = @report.hide
    elsif !@report.nil? && current_user.role == 'guardian'
      @hide = @report.hide
    end

    sprint = @report.sprint
    sprint_goal = @learner.sprint_goals.includes(:knowledges, :skills, :communities).find_by(sprint: sprint)
    sprint_goal_knowledges = sprint_goal.knowledges.pluck(:subject_name) if sprint_goal

    # Set counts for conditional button display
    @sprint_goal_knowledges_count = sprint_goal&.knowledges&.count || 0
    @report_knowledges_count = @report.report_knowledges.count

    timelines = @learner.timelines
    .joins(:subject) # Ensure we join the subjects table
    .where('subjects.name IN (:sprint_knowledges) OR timelines.personalized_name IN (:sprint_knowledges)',
           sprint_knowledges: sprint_goal_knowledges)

    @lcs = []
    @report.lc_ids.each do |lc_id|
      lc = User.find_by(id: lc_id)
      @lcs << lc if lc
    end

    if sprint_goal && sprint_goal.sprint.end_date + 3.weeks >= Date.today

      knowledges = timelines.left_outer_joins(:subject, :exam_date)
                    .where('subjects.name IN (:sprint_knowledges) OR personalized_name IN (:sprint_knowledges)', sprint_knowledges: sprint_goal_knowledges)
                    .pluck('subjects.name', :personalized_name, :progress, :difference, 'exam_dates.date')


      knowledges.each do |data|

        name = data[1] || data[0]

        if sprint_goal.knowledges.find_by(subject_name: name).present?

          knowledge_record = @report.report_knowledges.find_by(subject_name: name)

          if knowledge_record
            # Set the personalized flag if the personalized_name is present
            knowledge_record.personalized = !data[1].nil?
            # Update or set the attributes as necessary
            if !knowledge_record.personalized
              knowledge_record.progress = data[2]
              knowledge_record.difference = data[3]
            end

            puts knowledge_record.errors.full_messages

            # Save each record individually to persist changes
            knowledge_record.save
            puts knowledge_record.errors.full_messages
          end

        end
      end

      timeline_done = timelines.joins(:subject).find_by(subjects: { name: "Travel & Tourism IGCSE (M50% done)" })
      timeline_not_done = timelines.joins(:subject).find_by(subjects: { name: "Travel & Tourism IGCSE (M50% not done)" })

      if timeline_done || timeline_not_done
        knowledge_record = @report.report_knowledges.find_by(subject_name: "Travel & Tourism IGCSE")
        if knowledge_record
          timeline = timeline_done || timeline_not_done
          knowledge_record.progress = timeline&.progress || 0
          knowledge_record.difference = timeline&.difference || 0
          knowledge_record.save
        end
      end
    end

    if current_user.role == 'learner' && @learner == current_user
      # The learner can edit their report
      @role = 'learner'
    elsif (current_user.role == 'lc' || current_user.role == 'rm') && ((current_user.hubs & @learner.hubs).any? || @learner.main_hub&.name&.include?("Remote"))
      # The LC can edit the report related to them
      @role = 'lc'
    elsif current_user.role == 'admin'
      # The admin can edit any report
      @role = 'learner'
    else
      # Handle unauthorized access, e.g., redirect or show an error
      redirect_to root_path, alert: 'You do not have permission to edit this report.'
    end

    # Add the current LC to lc_ids if not already present
    if current_user.role == 'lc' && !@report.lc_ids.include?(current_user.id)
      @report.lc_ids = (@report.lc_ids + [current_user.id]).uniq
      @report.save
    end
  end

  def update
    if @report.update(report_params)
      redirect_to params[:redirect_path] || reports_path, notice: 'Report was successfully updated.'
    else
      render json: { errors: @report.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def toggle_hide
    lcs = @report.user.learner_info.learning_coaches || []

    lc_ids = lcs.present? ? lcs.map(&:id) : []

    @report.update(hide: !@report.hide, lc_ids: lc_ids)
    redirect_back fallback_location: reports_path, notice: "Visibility toggled successfully."
  end

  def update_knowledges
    if @report.update(report_knowledge_params)
      redirect_to edit_report_path(@report), notice: 'Knowledge was successfully updated.'
    else
      redirect_to edit_report_path(@report), notice: 'Knowledge was successfully updated.'
    end
  end

  def destroy_report_knowledge
    @report_knowledge = @report.report_knowledges.find(params[:knowledge_id])

    if @report_knowledge.destroy
      redirect_to edit_report_path(@report), notice: 'Knowledge record deleted successfully.'
    else
      redirect_to edit_report_path(@report), alert: 'Failed to delete the knowledge record.'
    end
  end

  def reset_knowledges_from_sprint_goal
    @learner = @report.user
    sprint = @report.sprint
    sprint_goal = @learner.sprint_goals.includes(:knowledges).find_by(sprint: sprint)

    if sprint_goal.nil?
      redirect_to edit_report_path(@report), alert: 'No sprint goal found for this report.'
      return
    end

    created_count = 0
    skipped_count = 0
    subjects = Subject.pluck(:name).to_set

    sprint_goal.knowledges.each do |knowledge|
      # Skip if knowledge doesn't have a subject_name
      next unless knowledge.subject_name.present?

      # Check if report_knowledge already exists by knowledge_id or subject_name
      existing_report_knowledge = @report.report_knowledges.find_by(knowledge_id: knowledge.id) ||
                                  @report.report_knowledges.find_by(subject_name: knowledge.subject_name)

      if existing_report_knowledge
        skipped_count += 1
        next
      end

      # Determine subject_name (handle Travel & Tourism special case)
      subject_name = if knowledge.subject_name == "Travel & Tourism IGCSE (M50% not done)" ||
                         knowledge.subject_name == "Travel & Tourism IGCSE (M50% done)"
                       "Travel & Tourism IGCSE"
                     else
                       knowledge.subject_name
                     end

      # Determine if personalized and get progress/difference
      if subjects.include?(subject_name)
        personalized = false
        subject = Subject.find_by(name: subject_name)
        timeline = @learner.timelines.find_by(subject_id: subject&.id)
        progress = timeline&.progress || 0
        difference = timeline&.difference || 0
      else
        personalized = true
        progress = nil
        difference = nil
      end

      # Create the report_knowledge
      begin
        @report.report_knowledges.create!(
          knowledge_id: knowledge.id,
          subject_name: subject_name,
          exam_season: knowledge.exam_season,
          personalized: personalized,
          progress: progress,
          difference: difference
        )
        created_count += 1
      rescue => e
        Rails.logger.error "Failed to create ReportKnowledge for Knowledge ID: #{knowledge.id}: #{e.message}"
      end
    end

    if created_count > 0
      redirect_to edit_report_path(@report), notice: "#{created_count} knowledge record(s) created. #{skipped_count} already existed."
    else
      redirect_to edit_report_path(@report), notice: "All knowledge records already exist. #{skipped_count} skipped."
    end
  end


  def report
    # Queries
    @report = Report.find(params[:id])
    @learner = @report.user

    if current_user.role == 'guardian' && current_user.kids.exclude?(@learner.id)
      redirect_back fallback_location: root_path, alert: "You do not have permission to access this report."
        return
    elsif current_user.role == 'learner' && current_user != @learner
      redirect_back fallback_location: root_path, alert: "You do not have permission to access this report."
      return
    elsif current_user.role == 'lc' && current_user.hubs.exclude?(@learner.main_hub) && !@learner.main_hub&.name&.include?("Remote")
      redirect_back fallback_location: root_path, alert: "You do not have permission to access this report."
      return
    elsif current_user.role == 'admin'

    end
    @attendance = calc_sprint_presence(@learner, @report.sprint) if @report&.sprint
    @report_activities = @report.report_activities
    @lcs = []
    @report.lc_ids.each do |lc_id|
      lc = User.find_by(id: lc_id)
      @lcs << lc if lc
    end


    pdf = Prawn::Document.new

    # Header Section with Logo and Learner Info
    cursor = pdf.cursor

    # Left Section (Learner and Hub Info)
    pdf.bounding_box([0, cursor], width: pdf.bounds.width / 3) do
      pdf.text "#{@learner.full_name}", size: 18, style: :bold
      pdf.text "#{@learner.users_hubs.find_by(main: true)&.hub.name} Hub", size: 15
    end

    # Center Section (Sprint Info)
    pdf.bounding_box([pdf.bounds.width / 3, cursor], width: pdf.bounds.width / 3) do
      pdf.text "#{@report.sprint.name} / #{@report.sprint.start_date.year}", size: 12, style: :bold, align: :center
      pdf.text "#{@report.sprint.start_date.strftime("%d %b")} - #{@report.sprint.end_date.strftime("%d %b")}", size: 12, align: :center
    end

    # Right Section (Logo)
    pdf.bounding_box([pdf.bounds.width * 2 / 3, cursor], width: pdf.bounds.width / 3) do
      pdf.image Rails.root.join("app/assets/images/logoreport.png"), width: 130, height: 65, position: :right
    end

    # Add a line separating the header from the rest of the PDF
    pdf.move_down 10
    pdf.stroke_color "000000" # Black color for line
    pdf.stroke_line([0, pdf.cursor], [pdf.bounds.width, pdf.cursor]) # Draw horizontal line at current cursor position
    pdf.move_down 10

    # Add attendance breakdown in one line
    pdf.text "Attendance: #{@attendance}% | Present: #{@p} | Working away: #{@wa} | Unjustified absences: #{@ul} | Justified absences: #{@jl} | Holidays: #{@h}", size: 10, align: :center

    pdf.move_down 10

    # General Comments Section
    print_section(pdf, sanitize_text_for_prawn(@report.general), "1. General Comment", 16)
    pdf.move_down 15

    # Knowledge Section (Table)
    title_height = pdf.height_of("2. Knowledge", size: 16, style: :bold)
    header_data = [["Subject", "Progress", "+/-", "Grade", "Exam"]]
    header_height = calculate_row_height(pdf, header_data, { 0 => 108, 1 => 108, 2 => 108, 3 => 108, 4 => 108 }, font_size: 12)
    table_data = [["Subject", "Progress", "+/-", "Grade", "Exam"]] + @report.report_knowledges.map do |knowledge|
      [
        knowledge.subject_name,
        knowledge.progress.present? && knowledge.progress.is_a?(Integer) ? "#{knowledge.progress}%" : (knowledge.progress || 'N/A'),
        knowledge.difference.present? && knowledge.progress.is_a?(Integer) ? "#{knowledge.difference}%" : (knowledge.difference || 'N/A'),
        knowledge.grade.presence || 'N/A',
        knowledge.exam_season.presence || 'N/A'
      ]
    end
    sample_row = table_data[1]
    row_height = sample_row ? calculate_row_height(pdf, sample_row, { 0 => 108, 1 => 108, 2 => 108, 3 => 108, 4 => 108 }, font_size: 12) : 0

    # Check if there's only room for the title, but not the table
    if pdf.cursor < (title_height + header_height + row_height + 40)
      pdf.start_new_page
    end

    pdf.text "2. Knowledge", size: 16, style: :bold
    pdf.table(table_data, header: true, width: 540) do
      # Set background color and text style for the header row
      row(0).background_color = 'D5F000'
      row(0).font_style = :bold # Make the header text bold
    end

    pdf.move_down 20

    print_section(pdf, sanitize_text_for_prawn(@report.lc_comment), "2.1. Learning Coach Comment", 14)
    pdf.move_down 15

    print_section(pdf, sanitize_text_for_prawn(@report.reflection), "2.2. Learner's Reflection", 14)
    pdf.move_down 15

    # Skills & Community Section
    title_height = pdf.height_of("Skills & Community", size: 16, style: :bold)
    header_data = [["Goal", "Learner's Reflection"]]
    header_height = calculate_row_height(pdf, header_data, { 0 => 135, 1 => 405 }, font_size: 12)
    table_data = [["Goal", "Learner's Reflection"]] + @report_activities.map do |activity|
      [
        sanitize_text_for_prawn("#{activity.activity.capitalize} - #{activity.goal}"),
        sanitize_text_for_prawn(activity.reflection)
      ]
    end
    sample_row = table_data[1]
    row_height = sample_row ? calculate_row_height(pdf, sample_row, { 0 => 135, 1 => 405 }, font_size: 12) : 0

    # Check if there's only room for the title, but not the table
    if pdf.cursor < (title_height + header_height + row_height + 40)
      pdf.start_new_page
    end

    pdf.text "3. Skills & Community", size: 16, style: :bold
    # Define the table and add a background color to the header row
    pdf.table(table_data, header: true, width: 540, column_widths: { 0 => 135, 1 => 405 }, cell_style: { overflow: :shrink_to_fit }) do
      # Set background color and text style for the header row
      row(0).background_color = 'D5F000'
      row(0).font_style = :bold # Make the header text bold
    end

    pdf.move_down 20

    # Key Development Areas (KDA) Section
    title_height = pdf.height_of("4. Key Development Areas", size: 16, style: :bold)
    secound_title_height = pdf.height_of("4.1. Learner's Reflection", size: 14, style: :bold) + 10
    header_data = ["KDA", "Learner's Reflection"]
    header_height = calculate_row_height(pdf, header_data, { 0 => 80, 1 => 460 }, font_size: 12)
    sample_row = ["Self-Directed Learning", sanitize_text_for_prawn(@report.sdl)]
    row_height = calculate_row_height(pdf, sample_row, { 0 => 80, 1 => 460 }, font_size: 12)

    # Check if there's only room for the title, but not the table
    if pdf.cursor < (title_height + secound_title_height + header_height + row_height + 40)
      pdf.start_new_page
    end

    # Key Development Areas (KDA) Section
    pdf.text "4. Key Development Areas", size: 16, style: :bold
    pdf.move_down 10
    pdf.text "4.1. Learner's Reflection", size: 14, style: :bold
    table_data = [
      ["KDA", "Learner's Reflection"],
      ["Self-Directed Learning", sanitize_text_for_prawn(@report.sdl)],
      ["Initiative", sanitize_text_for_prawn(@report.ini)],
      ["Motivation", sanitize_text_for_prawn(@report.mot)],
      ["Peer-to-Peer Learning", sanitize_text_for_prawn(@report.p2p)],
      ["Hub Participation", sanitize_text_for_prawn(@report.hubp)]
    ]

    pdf.table(table_data, header: true, width: 540, column_widths: { 0 => 80, 1 => 460 }, cell_style: { overflow: :shrink_to_fit }) do |table|
      # Set background color and text style for the header row
      table.row(0).background_color = 'D5F000'
      table.row(0).font_style = :bold
    end

    pdf.move_down 20

    # Rubric Table
    title_height = pdf.height_of("Learning Coach's Rubric", size: 14, style: :bold)
    header_data = ["KDA", "Level", "Area of Impact"]
    header_height = calculate_row_height(pdf, header_data, { 0 => 80, 1 => 80, 2 => 380 }, font_size: 12)
    sample_row = [
      { content: "Self-Directed Learning", rowspan: 5 },
      @report.sdl_long_term_plans.present? ? @report.sdl_long_term_plans.capitalize : "",
      "The learner sets effective long-term plans."
    ]
    row_height = calculate_row_height(pdf, sample_row, { 0 => 80, 1 => 80, 2 => 380 }, font_size: 12)

    # Check if there's only room for the title, but not the table
    if pdf.cursor < (title_height + header_height + row_height + 40)
      pdf.start_new_page
    end
    pdf.text "4.2 Learning Coach's Rubric", size: 14, style: :bold
    # Data Structure for the rubric table
    table_data = [
      ["KDA", "Level", "Area of Impact"],
      [{ content: "Self-Directed Learning", rowspan: 5 }, @report.sdl_long_term_plans.present? ? @report.sdl_long_term_plans.capitalize : "", "The learner sets effective long-term plans."],
      [@report.sdl_week_organization.present? ? @report.sdl_week_organization.capitalize : "", "The learner organizes their week effectively."],
      [@report.sdl_achieve_goals.present? ? @report.sdl_achieve_goals.capitalize : "", "The learner achieves their goals."],
      [@report.sdl_study_techniques.present? ? @report.sdl_study_techniques.capitalize : "", "The learner uses effective study techniques."],
      [@report.sdl_initiative_office_hours.present? ? @report.sdl_initiative_office_hours.capitalize : "", "The learner takes initiative to arrange office hours with Course Managers (CMs)."],
      [{ content: "Initiative", rowspan: 2 }, @report.ini_new_activities.present? ? @report.ini_new_activities.capitalize : "", "The learner seeks out new activities and experiences."],
      [@report.ini_goal_setting.present? ? @report.ini_goal_setting.capitalize : "", "The learner sets goals across the three key pillars."],
      [{ content: "Motivation", rowspan: 2 }, @report.mot_integrity.present? ? @report.mot_integrity.capitalize : "", "The learner completes work with integrity and to the best of their ability."],
      [@report.mot_improvement.present? ? @report.mot_improvement.capitalize : "", "The learner actively seeks ways to improve in all areas."],
      [{ content: "Peer-to-Peer Learning", rowspan: 2 }, @report.p2p_support_from_peers.present? ? @report.p2p_support_from_peers.capitalize : "", "The learner seeks support from peers when needed."],
      [@report.p2p_support_to_peers.present? ? @report.p2p_support_to_peers.capitalize : "", "The learner offers support to peers when needed."],
      [{ content: "Hub Participation", rowspan: 4 }, @report.hub_cleanliness.present? ? @report.hub_cleanliness.capitalize : "", "The learner actively contributes to keeping the hub clean and organized."],
      [@report.hub_respectful_behavior.present? ? @report.hub_respectful_behavior.capitalize : "", "The learner behaves respectfully and is not disruptive."],
      [@report.hub_welcome_others.present? ? @report.hub_welcome_others.capitalize : "", "The learner makes efforts to welcome others to the hub."],
      [@report.hub_participation.present? ? @report.hub_participation.capitalize : "", "The learner actively participates in hub activities."]
    ]
    pdf.table(table_data, header: true, width: 540, column_widths: { 0 => 80, 1 => 80, 2 => 380 }) do
      # Set background color and text style for the header row
      row(0).background_color = 'D5F000'
      row(0).font_style = :bold # Make the header text bold
    end

    # Check if there's enough space for the footer; if not, add a new page
    if pdf.cursor < 60
      pdf.start_new_page
    end

    # Move to the last page and add the footer
    pdf.go_to_page(pdf.page_count) # Go to the last page

    # Set the position near the bottom of the last page
    pdf.bounding_box([0, 50], width: pdf.bounds.width, height: 50) do
      # Draw a separator line
      pdf.stroke_color "000000" # Black color for line
      pdf.stroke_line([0, pdf.cursor], [pdf.bounds.width, pdf.cursor]) # Draw horizontal line

      pdf.move_down 10

      # Left side (site info)
      pdf.text "www.bravegenerationacademy.com", size: 10, align: :left, inline_format: true

      # Right side (LC emails)
      pdf.bounding_box([pdf.bounds.width - 300, pdf.cursor + 10], width: 300) do
        @lcs.each do |lc|
          pdf.text "#{lc.full_name}: #{lc.email}", align: :right, size: 10
        end
      end
    end

    filename = "#{@learner.full_name}_#{@report.sprint.name}/#{@report.sprint.start_date.year}.pdf"
    send_data pdf.render,
          type: 'application/pdf',
          disposition: 'inline',
          filename: filename
  end

  def calculate_row_height(pdf, row_data, column_widths, font_size: 12)
    row_data.each_with_index.map do |cell, col_index|
      # Measure cell content, handling hashes for rowspan/cell formatting
      cell_content = cell.is_a?(Hash) ? cell[:content].to_s : cell.to_s
      pdf.height_of(cell_content, width: column_widths[col_index], size: font_size)
    end.max # Take the tallest cell in the row
  end

  def print_section(pdf, comment_text, section_title, title_size)
    # Ensure there is content to print
    comment_text = comment_text.presence || "[Empty]"
    pdf.font("Helvetica")

    # Print the title (header)
    if pdf.cursor < 60
      pdf.start_new_page
    end
    pdf.text section_title, size: title_size, style: :bold
    pdf.move_down 10

    # Set up text properties
    font_size = 12
    available_width = pdf.bounds.width

    # Keep track of remaining text that wasn't printed yet
    remaining_text = comment_text

    # Set up box properties
    box_padding = 8
    box_radius = 8
    leading = 5

    # Process the text
    loop do
      # Calculate the available height on the current page
      available_height = pdf.cursor - 20 # Padding at the bottom

      # Calculate how many lines of text can fit in the available height
      line_height = pdf.height_of("Test", size: font_size) + leading # Single line height for the font size
      max_lines = (available_height / line_height).to_i

      # Split remaining text into lines that fit within the available width
      text_lines = break_text_into_lines(pdf, remaining_text, font_size, available_width - (2 * box_padding) - 2)

      # If there is no space for even one line, start a new page
      if max_lines <= 0
        pdf.start_new_page
        pdf.text "#{section_title} (Continuation)", size: title_size, style: :bold
        pdf.move_down 10
        next
      end

      # If the text doesn't fit, print as much as possible
      lines_to_print = if text_lines.length <= max_lines
                         text_lines
                       else
                         text_lines.first(max_lines)
                       end

      # Calculate the height of the box (text height + padding)
      text_height = lines_to_print.length * line_height
      box_height = text_height + (2 * box_padding) - leading

      # Draw the bounding box with rounded edges and text inside it
      pdf.bounding_box([0, pdf.cursor], width: available_width, height: box_height) do
        # Draw the rounded rectangle
        pdf.stroke_color "000000"
        pdf.fill_color "FFFFFF"
        pdf.fill_and_stroke_rounded_rectangle([0, box_height], available_width, box_height, box_radius)

        # Print the text inside the box
        pdf.fill_color "000000"
        pdf.text_box lines_to_print.join("\n"), at: [box_padding, box_height - box_padding], leading: leading,
                     width: available_width - (2 * box_padding), size: font_size
      end

      remaining_text = text_lines[max_lines..].to_a.join("\n")

      # If there is more text to print, start a new page
      if remaining_text.length > 0
        pdf.start_new_page
        pdf.text "#{section_title} (Continuation)", size: title_size, style: :bold
        pdf.move_down 10 # Padding for the next section
      else
        break # All text has been printed
      end
    end
  end

  def break_text_into_lines(pdf, text, size, width)
    lines = []

    # Split the text into segments using \n to preserve explicit newlines
    paragraphs = text.split("\n", -1) # Preserve empty lines from explicit newlines

    paragraphs.each do |paragraph|

      if paragraph.empty?
        # Add an empty line to represent the newline
        lines << ""
        next
      end

      current_line = ""
      words = paragraph.split(" ")

      words.each do |word|
        test_line = current_line.empty? ? word : "#{current_line} #{word}"

        # Check if the current line fits within the width
        if pdf.width_of(test_line, size: size) > width
          # Justify the current line before adding it to the list
          lines << justify_line(current_line.strip, pdf, size, width)
          current_line = word
        else
          # Otherwise, continue building the current line
          current_line = test_line
        end
      end

      # Add the last line of the paragraph (not justified)
      lines << current_line.strip
    end

    lines
  end

  # Updated `justify_line` function remains unchanged
  def justify_line(line, pdf, size, width)
    words = line.split(" ")
    return line if words.size <= 1 # Single-word lines can't be justified

    # Calculate total text width and available space
    text_width = words.sum { |word| pdf.width_of(word, size: size) }
    space_width = pdf.width_of(" ", size: size) # Width of a single space
    total_space = width - text_width

    # Distribute extra space evenly
    gaps = words.size - 1
    extra_space_per_gap = total_space / gaps.to_f

    # Construct the justified line
    justified_line = words[0]
    words[1..].each do |word|
      # Calculate exact space for the gap
      space_for_gap = space_width + extra_space_per_gap
      justified_line += " " * (space_for_gap / space_width).floor + word
    end

    # Adjust the line to fit the exact width if needed
    while pdf.width_of(justified_line, size: size) > width
      if justified_line.match?(/  +/) # Check for multiple spaces
        justified_line.sub!(/  +/, " ") # Remove one space from the first gap with multiple spaces
      else
        break # No extra spaces left to adjust
      end
    end

    justified_line
  end

  def update_activities
    if @report.update(report_activities_params)
      redirect_to edit_report_path(@report), notice: 'Activity was successfully updated.'
    else
      redirect_to edit_report_path(@report), alert: 'Failed to update Knowledge.' if update fails
    end
  end

  def remove_lc
    @report = Report.find(params[:id])
    lc_id = params[:lc_id].to_i

    if @report.lc_ids.include?(lc_id)
      @report.lc_ids = @report.lc_ids - [lc_id]

      if @report.save
        render json: { success: true }
      else
        render json: { success: false, error: 'Failed to remove Learning Coach' }
      end
    else
      render json: { success: false, error: 'Learning Coach not found in report' }
    end
  end


  private

  def sanitize_text_for_prawn(text)
    text.to_s.encode("Windows-1252", invalid: :replace, undef: :replace, replace: " ")
  end

  def report_knowledge_params
    params.require(:report).permit(report_knowledges_attributes: [:id, :subject_name, :progress, :difference, :grade, :exam_season])
  end

  def report_activities_params
    params.require(:report).permit(report_activities_attributes: [:id, :activity, :goal, :reflection])
  end

  def report_params
    params.require(:report).permit(:user_id, :sprint_id, :general, :lc_comment, :reflection, :sdl, :ini, :mot, :p2p,
                                   :hubp, :sdl_long_term_plans, :sdl_week_organization, :sdl_achieve_goals, :sdl_study_techniques,
                                   :sdl_initiative_office_hours, :ini_new_activities, :ini_goal_setting, :mot_integrity, :mot_improvement,
                                   :p2p_support_from_peers, :p2p_support_to_peers, :hub_cleanliness, :hub_respectful_behavior, :hub_welcome_others,
                                   :hub_participation, report_activities_attributes: %i[id activity goal reflection _destroy],
                                                       report_knowledges_attributes: %i[id subject_name progress difference exam_season grade _destroy])
  end

  def calc_nav_dates(current_sprint)
    @next_date = current_sprint.end_date + 30
    @prev_date = current_sprint.start_date - 30
  end

  def current_sprint
    Sprint.find_by('start_date <= ? AND end_date >= ?', Date.today, Date.today)
  end

  def set_report
    @report = Report.find(params[:id])
  end

  def calc_sprint_presence(user, sprint)
    date_range = sprint.start_date..sprint.end_date

    @attendances = Attendance.where(user_id: user.id, attendance_date: date_range)
    @ul = 0
    @jl = 0
    @p = 0
    @wa = 0
    @h = 0

    @attendances.each do |attendance|
      if attendance.absence == 'Unjustified Leave'
        @ul += 1
      elsif attendance.absence == 'Justified Leave'
        @jl += 1
      elsif attendance.absence == 'Present'
        @p += 1
      elsif attendance.absence == 'Working Away'
        @wa += 1
      elsif attendance.absence == 'Holiday'
        @h += 1
      end
    end

    @absence_count = @ul + @jl
    @present_count = @p + @wa

    if (@absence_count.zero? && @present_count.zero?) || @present_count.zero?
      presence = 0
    else
      presence = ((@present_count.to_f / (@present_count + @absence_count)) * 100).round
    end

    presence
  end
end
