class NoteSummarizationService
  def initialize(notes, learner: nil, start_date: nil, end_date: nil)
    @notes = notes
    @learner = learner
    @start_date = start_date
    @end_date = end_date

    @api_key = ENV['OPENAI_API_KEY'].presence ||
               ENV['OPENAI_ACCESS_TOKEN'].presence ||
               Rails.application.credentials.openai_api_key.presence

    if @api_key.present?
      @openai_client = OpenAI::Client.new(api_key: @api_key)
    else
      Rails.logger.warn "NoteSummarizationService: No OpenAI API key configured"
    end
  end

  def summarize(save_as_summary: true)
    return error_response("No notes provided") if @notes.empty?
    return error_response("OpenAI API key not configured") unless @api_key.present?

    # Check if there's an existing summary for this date range
    if save_as_summary && @learner.present? && @start_date.present? && @end_date.present?
      existing_summary = find_existing_summary

      if existing_summary
        Rails.logger.info "Found existing summary for date range #{@start_date} to #{@end_date}"
        return load_summary_from_ai_summary(existing_summary)
      end
    end

    # Prepare notes text
    notes_text = format_notes_for_ai

    # Generate comprehensive summary using AI (single call)
    summary = generate_ai_summary(notes_text)

    # Extract sections
    summary_text = extract_summary_section(summary)
    key_points = extract_key_points_section(summary)
    recommendations = extract_recommendations_section(summary)
    action_items = extract_action_items_from_notes

    # Check if we got a fallback summary
    if is_fallback_summary?(summary_text)
      # If there are new notes but API failed, return a more helpful message
      return {
        success: false,
        error: "Unable to generate summary at this time. The AI service is temporarily unavailable. Please try again in a few moments.",
        summary: nil,
        key_points: [],
        recommendations: nil,
        action_items: [],
        categories_breakdown: {}
      }
    end

    result = {
      success: true,
      summary: summary_text,
      key_points: key_points,
      recommendations: recommendations,
      action_items: action_items || [],
      categories_breakdown: categorize_notes || {}
    }

    # Only save as AiSummary if it's a real AI-generated summary (not the fallback message)
    if save_as_summary && @learner.present? && !is_fallback_summary?(summary_text)
      save_summary_as_ai_summary(result)
    end

    result
  rescue => e
    Rails.logger.error "NoteSummarizationService error: #{e.message}"
    Rails.logger.error e.backtrace.first(10).join("\n")
    error_response("Error generating summary: #{e.message}")
  end

  def weekly_summary(week_start: nil, week_end: nil, save_as_summary: true)
    week_start ||= Date.today.beginning_of_week
    week_end ||= Date.today.end_of_week

    week_notes = @notes.where(date: week_start..week_end)
    return error_response("No notes found for this week") if week_notes.empty?

    # Create temporary service instance for this week's notes
    service = NoteSummarizationService.new(week_notes, learner: @learner, start_date: week_start, end_date: week_end)
    summary_data = service.summarize(save_as_summary: save_as_summary)

    {
      success: true,
      week: "#{week_start.strftime('%d %b')} - #{week_end.strftime('%d %b %Y')}",
      total_notes: week_notes.count,
      summary_data: summary_data
    }
  end

  private

  def format_notes_for_ai
    notes_text = []

    # Order by date (oldest first) to show chronological progression
    ordered_notes = @notes.order(date: :asc)

    # Add date range context
    if ordered_notes.any?
      first_date = ordered_notes.first.date
      last_date = ordered_notes.last.date
      days_span = (last_date - first_date).to_i

      notes_text << "=== NOTES TIMELINE ==="
      notes_text << "Date Range: #{first_date.strftime('%d %B %Y')} to #{last_date.strftime('%d %B %Y')} (#{days_span} days)"
      notes_text << "Total Notes: #{ordered_notes.count}"
      notes_text << ""
    end

    ordered_notes.each_with_index do |note, index|
      note_entry = []
      note_entry << "Note #{index + 1} - Date: #{note.date.strftime('%d %B %Y')} (#{note.date.strftime('%A')})"
      note_entry << "Days since first note: #{(note.date - ordered_notes.first.date).to_i}" if index > 0
      note_entry << "Category: #{note.category}"
      note_entry << "Topic: #{note.topic}"
      note_entry << "Follow-up Action: #{note.follow_up_action}" if note.follow_up_action.present?
      note_entry << "Status: #{note.status}"
      notes_text << note_entry.join("\n")
    end

    notes_text.join("\n\n---\n\n")
  end

  def generate_ai_summary(notes_text)
    unless @openai_client.present?
      Rails.logger.error "OpenAI client not initialized"
      return fallback_summary
    end

    learner_context = @learner ? "for learner #{@learner.full_name}" : ""

    prompt = <<~PROMPT
      Analyze the following notes #{learner_context} and provide a structured response.

      IMPORTANT: Pay close attention to the DATES of each note. Consider:
      - Chronological progression and trends over time
      - How issues or behaviors have evolved
      - Time gaps between notes
      - Recent developments vs older concerns
      - Whether patterns are improving, worsening, or stable

      Notes (ordered chronologically):
      #{notes_text}

      Provide your response in this exact format:

      SUMMARY:
      [2-4 sentence overall summary that mentions key dates and timeline patterns]

      KEY POINTS:
      - [First key point - include date context if relevant]
      - [Second key point - include date context if relevant]
      - [Third key point - include date context if relevant]
      - [Fourth key point - include date context if relevant]
      - [Fifth key point - include date context if relevant]

      RECOMMENDATIONS:
      [Specific recommendations for the learning coach, 2-4 sentences. Consider the timeline and urgency based on dates]

      Make sure to use the exact section headers: SUMMARY:, KEY POINTS:, and RECOMMENDATIONS:
    PROMPT

    begin
      # Use the completions API (compatible with existing setup)
      response = @openai_client.completions(
        engine: "gpt-4o-mini",
        prompt: prompt,
        max_tokens: 1000,
        temperature: 0.7
      )

      Rails.logger.info "OpenAI response received: #{response.class}"

      # Try both string and symbol keys
      summary_text = response.dig("choices", 0, "text")&.strip ||
                     response.dig(:choices, 0, :text)&.strip ||
                     response.dig("choices", 0, :text)&.strip ||
                     response.dig(:choices, 0, "text")&.strip

      if summary_text.present?
        Rails.logger.info "Successfully extracted summary text (length: #{summary_text.length})"
        summary_text
      else
        Rails.logger.warn "OpenAI response had no text. Response keys: #{response.keys.inspect if response.respond_to?(:keys)}"
        Rails.logger.warn "Full response: #{response.inspect}"
        fallback_summary
      end
    rescue => e
      Rails.logger.error "OpenAI API error: #{e.class} - #{e.message}"
      Rails.logger.error e.backtrace.first(5).join("\n")

      # Fallback to gpt-3.5-turbo-instruct if gpt-4o-mini fails
      if e.message.include?("model") || e.message.include?("engine")
        Rails.logger.info "Falling back to gpt-3.5-turbo-instruct"
        begin
          response = @openai_client.completions(
            engine: "gpt-3.5-turbo-instruct",
            prompt: prompt,
            max_tokens: 1000,
            temperature: 0.7
          )

          # Try both string and symbol keys
          summary_text = response.dig("choices", 0, "text")&.strip ||
                         response.dig(:choices, 0, :text)&.strip ||
                         response.dig("choices", 0, :text)&.strip ||
                         response.dig(:choices, 0, "text")&.strip

          if summary_text.present?
            Rails.logger.info "Successfully extracted summary from fallback model (length: #{summary_text.length})"
            summary_text
          else
            Rails.logger.warn "Fallback model response had no text. Response keys: #{response.keys.inspect if response.respond_to?(:keys)}"
            Rails.logger.warn "Full response: #{response.inspect}"
            fallback_summary
          end
        rescue => fallback_error
          Rails.logger.error "Fallback model also failed: #{fallback_error.class} - #{fallback_error.message}"
          fallback_summary
        end
      else
        fallback_summary
      end
    end
  end

  def extract_summary_section(full_text)
    return "" if full_text.blank?

    # Extract the SUMMARY section
    if full_text.include?("SUMMARY:")
      summary_match = full_text.match(/SUMMARY:\s*(.*?)(?=KEY POINTS:|RECOMMENDATIONS:|$)/m)
      summary_match ? summary_match[1].strip : full_text.split("\n").first(3).join("\n")
    else
      # Fallback: use first paragraph
      full_text.split("\n\n").first || full_text
    end
  end

  def extract_key_points_section(full_text)
    return [] if full_text.blank?

    # Extract the KEY POINTS section
    if full_text.include?("KEY POINTS:")
      key_points_match = full_text.match(/KEY POINTS:\s*(.*?)(?=RECOMMENDATIONS:|$)/m)
      if key_points_match
        points = key_points_match[1].strip.split("\n")
        points.select { |p| p.strip.start_with?("-") || p.strip.match(/^\d+\./) }
              .map { |p| p.strip.gsub(/^[-•]\s*/, "").gsub(/^\d+\.\s*/, "") }
              .reject(&:blank?)
      else
        []
      end
    else
      # Fallback: look for bullet points anywhere
      full_text.split("\n")
               .select { |line| line.strip.start_with?("-") || line.strip.match(/^\d+\./) }
               .map { |line| line.strip.gsub(/^[-•]\s*/, "").gsub(/^\d+\.\s*/, "") }
               .reject(&:blank?)
               .first(5)
    end
  end

  def extract_recommendations_section(full_text)
    return "" if full_text.blank?

    # Extract the RECOMMENDATIONS section
    if full_text.include?("RECOMMENDATIONS:")
      rec_match = full_text.match(/RECOMMENDATIONS:\s*(.*?)$/m)
      rec_match ? rec_match[1].strip : ""
    else
      # Fallback: look for recommendations-related text
      lines = full_text.split("\n")
      rec_index = lines.find_index { |l| l.downcase.include?("recommend") }
      if rec_index
        lines[rec_index..-1].join("\n").gsub(/.*recommendations?:?\s*/i, "").strip
      else
        ""
      end
    end
  end

  def extract_action_items_from_notes
    # Get action items from notes directly (no AI call needed)
    action_items = []

    @notes.where.not(follow_up_action: [nil, ""]).each do |note|
      if note.status != "Completed"
        action_items << {
          note_id: note.id,
          date: note.date,
          category: note.category,
          action: note.follow_up_action,
          status: note.status
        }
      end
    end

    action_items
  end

  def categorize_notes
    @notes.group_by(&:category).transform_values(&:count) || {}
  end

  def find_existing_summary
    return nil unless @learner.present? && @start_date.present? && @end_date.present?

    @learner.ai_summaries
            .where(start_date: @start_date, end_date: @end_date)
            .order(created_at: :desc)
            .first
  end

  def load_summary_from_ai_summary(ai_summary)
    action_items = extract_action_items_from_notes

    {
      success: true,
      summary: ai_summary.summary.presence || "Summary loaded from saved record.",
      key_points: ai_summary.key_points.present? ? JSON.parse(ai_summary.key_points) : [],
      recommendations: ai_summary.recommendations.presence || "",
      action_items: action_items || [],
      categories_breakdown: categorize_notes || {},
      from_saved_summary: true,
      start_date: ai_summary.start_date,
      end_date: ai_summary.end_date
    }
  rescue JSON::ParserError
    # If key_points is not JSON, try to parse as text
    {
      success: true,
      summary: ai_summary.summary.presence || "Summary loaded from saved record.",
      key_points: ai_summary.key_points.present? ? ai_summary.key_points.split("\n").reject(&:blank?) : [],
      recommendations: ai_summary.recommendations.presence || "",
      action_items: action_items || [],
      categories_breakdown: categorize_notes || {},
      from_saved_summary: true,
      start_date: ai_summary.start_date,
      end_date: ai_summary.end_date
    }
  end

  def save_summary_as_ai_summary(summary_data)
    return unless @learner.present? && @start_date.present? && @end_date.present?

    begin
      # Convert key_points array to JSON string
      key_points_json = summary_data[:key_points].is_a?(Array) ?
                        summary_data[:key_points].to_json :
                        summary_data[:key_points].to_s

      ai_summary = AiSummary.create(
        user: @learner,
        summary: summary_data[:summary],
        key_points: key_points_json,
        recommendations: summary_data[:recommendations],
        start_date: @start_date,
        end_date: @end_date,
        notes_count: @notes.count
      )

      if ai_summary.persisted?
        Rails.logger.info "Summary saved as AiSummary #{ai_summary.id} for learner #{@learner.id}"
      else
        Rails.logger.error "Failed to save AI summary: #{ai_summary.errors.full_messages.join(', ')}"
        Rails.logger.error "Summary attributes: #{ai_summary.attributes.inspect}"
      end
    rescue => e
      Rails.logger.error "Error in save_summary_as_ai_summary: #{e.class} - #{e.message}"
      Rails.logger.error e.backtrace.first(10).join("\n")
    end
  end

  def fallback_summary
    "Summary generation is currently unavailable. Please review the notes manually."
  end

  def is_fallback_summary?(summary_text)
    return false if summary_text.blank?
    summary_text.strip == fallback_summary.strip ||
    summary_text.include?("Summary generation is currently unavailable")
  end

  def error_response(message)
    {
      success: false,
      error: message,
      summary: nil,
      key_points: [],
      recommendations: nil,
      action_items: [],
      categories_breakdown: {}
    }
  end
end
