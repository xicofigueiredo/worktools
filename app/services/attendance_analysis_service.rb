class AttendanceAnalysisService
  def initialize(user: nil, hub: nil, start_date: nil, end_date: nil)
    @user = user
    @hub = hub
    @start_date = (start_date || 12.weeks.ago.beginning_of_week).to_date
    @end_date = (end_date || Date.today.end_of_week).to_date
  end

  # Main analysis method
  def analyze
    {
      learners_at_risk: learners_at_risk,
      attendance_performance_correlation: attendance_performance_correlation,
      attendance_trends: attendance_trends,
      weekly_breakdown: weekly_breakdown,
      performance_metrics: performance_metrics
    }
  end

  # Identify learners needing support based on attendance patterns
  def learners_at_risk
    learners = fetch_learners.compact
    at_risk = []

    learners.each do |learner|
      next if learner.nil?

      risk_score = calculate_risk_score(learner)
      next if risk_score[:score] < 0.3 # Only flag learners with significant risk

      at_risk << {
        learner: learner,
        risk_score: risk_score[:score],
        risk_factors: risk_score[:factors],
        attendance_rate: calculate_attendance_rate(learner),
        recent_attendance: recent_attendance_rate(learner),
        performance_impact: performance_impact(learner),
        avg_hours_at_hub: calculate_avg_hours_at_hub(learner)
      }
    end

    at_risk.sort_by { |l| -l[:risk_score] }
  end

  # Calculate correlation between attendance and performance
  def attendance_performance_correlation
    learners = fetch_learners.compact
    correlations = []

    learners.each do |learner|
      next if learner.nil?

      attendance_data = attendance_metrics(learner)
      performance_data = performance_metrics_for_learner(learner)

      next if attendance_data[:total_days] < 5 # Need minimum data points

      correlation = calculate_correlation(attendance_data, performance_data)

      correlations << {
        learner: learner,
        correlation: correlation,
        attendance_rate: attendance_data[:attendance_rate],
        average_performance: performance_data[:average_score],
        data_points: attendance_data[:total_days],
        avg_hours_at_hub: calculate_avg_hours_at_hub(learner)
      }
    end

    correlations.sort_by { |c| -c[:correlation].abs }
  end

  # Analyze attendance trends over time
  def attendance_trends
    learners = fetch_learners.compact
    trends = []

    learners.each do |learner|
      next if learner.nil?

      weekly_rates = calculate_weekly_attendance_rates(learner)
      trend = calculate_trend(weekly_rates)

      trends << {
        learner: learner,
        trend: trend,
        current_rate: weekly_rates.last || 0,
        previous_rate: weekly_rates[-2] || 0,
        average_rate: weekly_rates.any? ? (weekly_rates.sum / weekly_rates.size.to_f) : 0,
        weekly_rates: weekly_rates,
        avg_hours_at_hub: calculate_avg_hours_at_hub(learner)
      }
    end

    trends.sort_by { |t| t[:trend] } # Negative trends first
  end

  # Weekly breakdown of attendance
  def weekly_breakdown
    weeks = Week.where("start_date >= ? AND end_date <= ?", @start_date, @end_date).order(:start_date)
    breakdown = []

    weeks.each do |week|
      learners = fetch_learners
      week_data = {
        week: week,
        total_learners: learners.count,
        present_count: 0,
        absent_count: 0,
        late_count: 0,
        attendance_rate: 0
      }

      learners.each do |learner|
        attendances = learner.attendances.where(attendance_date: week.start_date..week.end_date)

        present_days = attendances.where(absence: 'Present').count
        absent_days = attendances.where.not(absence: ['Present', nil]).count

        week_data[:present_count] += present_days
        week_data[:absent_count] += absent_days
      end

      total_expected = learners.count * business_days_in_range(week.start_date, week.end_date)
      week_data[:attendance_rate] = total_expected > 0 ? (week_data[:present_count].to_f / total_expected * 100).round(1) : 0

      breakdown << week_data
    end

    breakdown
  end

  # Overall performance metrics
  def performance_metrics
    learners = fetch_learners
    {
      total_learners: learners.count,
      average_attendance_rate: calculate_average_attendance_rate(learners),
      learners_below_threshold: learners_below_threshold(learners).count,
      strong_correlation_count: strong_correlation_count,
      average_hours_at_hub: calculate_average_hours_at_hub(learners)
    }
  end

  private

  def fetch_learners
    if @user
      [@user].compact
    elsif @hub
      @hub.active_learners.map(&:user).compact
    else
      # If no hub specified, return empty array (should be set by controller)
      []
    end
  end

  def current_user_hub
    # This will be set by the controller if needed
    @hub
  end

  def calculate_risk_score(learner)
    factors = []
    score = 0.0

    # Factor 1: Low overall attendance rate
    attendance_rate = calculate_attendance_rate(learner)
    if attendance_rate < 70
      score += 0.3
      factors << "Low overall attendance (#{attendance_rate.round(1)}%)"
    end

    # Factor 2: Declining attendance trend
    recent_rate = recent_attendance_rate(learner, weeks: 2)
    older_rate = older_attendance_rate(learner, weeks: 4)
    if recent_rate < older_rate - 10
      score += 0.25
      factors << "Declining attendance trend (#{recent_rate.round(1)}% vs #{older_rate.round(1)}%)"
    end

    # Factor 3: High unjustified absences
    unjustified_rate = unjustified_absence_rate(learner)
    if unjustified_rate > 15
      score += 0.2
      factors << "High unjustified absences (#{unjustified_rate.round(1)}%)"
    end

    # Factor 4: Poor performance correlation
    perf_impact = performance_impact(learner)
    if perf_impact[:correlation] < -0.3
      score += 0.15
      factors << "Strong negative correlation with performance"
    end

    # Factor 5: Recent consecutive absences
    consecutive_absences = count_consecutive_absences(learner)
    if consecutive_absences >= 3
      score += 0.1
      factors << "#{consecutive_absences} consecutive absences"
    end

    { score: [score, 1.0].min, factors: factors }
  end

  def calculate_attendance_rate(learner)
    return 0 if learner.nil?

    attendances = learner.attendances.where(attendance_date: @start_date..@end_date)
    total_days = business_days_in_range(@start_date, @end_date)
    return 0 if total_days.zero?

    present_days = attendances.where(absence: 'Present').count
    (present_days.to_f / total_days * 100).round(1)
  end

  def recent_attendance_rate(learner, weeks: 2)
    return 0 if learner.nil?

    end_date = Date.today
    start_date = weeks.weeks.ago.beginning_of_week
    attendances = learner.attendances.where(attendance_date: start_date..end_date)
    total_days = business_days_in_range(start_date, end_date)
    return 0 if total_days.zero?

    present_days = attendances.where(absence: 'Present').count
    (present_days.to_f / total_days * 100).round(1)
  end

  def older_attendance_rate(learner, weeks: 4)
    return 0 if learner.nil?

    end_date = 2.weeks.ago.end_of_week
    start_date = weeks.weeks.ago.beginning_of_week
    attendances = learner.attendances.where(attendance_date: start_date..end_date)
    total_days = business_days_in_range(start_date, end_date)
    return 0 if total_days.zero?

    present_days = attendances.where(absence: 'Present').count
    (present_days.to_f / total_days * 100).round(1)
  end

  def unjustified_absence_rate(learner)
    return 0 if learner.nil?

    attendances = learner.attendances.where(attendance_date: @start_date..@end_date)
    total_days = business_days_in_range(@start_date, @end_date)
    return 0 if total_days.zero?

    unjustified = attendances.where(absence: 'Unjustified Leave').count
    (unjustified.to_f / total_days * 100).round(1)
  end

  def count_consecutive_absences(learner)
    return 0 if learner.nil?

    recent_attendances = learner.attendances
      .where(attendance_date: 4.weeks.ago..Date.today)
      .order(attendance_date: :desc)
      .limit(10)

    consecutive = 0
    recent_attendances.each do |attendance|
      break if attendance.absence == 'Present'
      consecutive += 1 if attendance.absence.present? && attendance.absence != 'Present'
    end
    consecutive
  end

  def performance_impact(learner)
    return { correlation: 0, attendance_rate: 0, average_performance: nil } if learner.nil?

    attendance_data = attendance_metrics(learner)
    performance_data = performance_metrics_for_learner(learner)

    correlation = calculate_correlation(attendance_data, performance_data)

    {
      correlation: correlation,
      attendance_rate: attendance_data[:attendance_rate],
      average_performance: performance_data[:average_score]
    }
  end

  def attendance_metrics(learner)
    return { total_days: 0, present_days: 0, absent_days: 0, attendance_rate: 0, weekly_rates: [] } if learner.nil?

    attendances = learner.attendances.where(attendance_date: @start_date..@end_date)
    total_days = business_days_in_range(@start_date, @end_date)
    present_days = attendances.where(absence: 'Present').count

    {
      total_days: total_days,
      present_days: present_days,
      absent_days: attendances.where.not(absence: ['Present', nil]).count,
      attendance_rate: total_days > 0 ? (present_days.to_f / total_days * 100) : 0,
      weekly_rates: calculate_weekly_attendance_rates(learner)
    }
  end

  def performance_metrics_for_learner(learner)
    return { assignment_scores: [], timeline_progress: [], goal_completion: 0, average_score: nil, data_points: 0 } if learner.nil?

    # Get assignment grades
    assignments = Assignment.where(user: learner)
      .where.not(grade: nil)
      .where("evaluation_date >= ?", @start_date)
      .order(:evaluation_date)

    # Get timeline progress
    timelines = learner.timelines
      .where("updated_at >= ?", @start_date)
      .where.not(progress: nil)

    # Get weekly goal completion
    weekly_goals = learner.weekly_goals
      .joins(:week)
      .where("weeks.start_date >= ?", @start_date)

    assignment_scores = assignments.map { |a| (a.grade.to_f / a.max_grade.to_f * 100) if a.max_grade&.positive? }.compact
    timeline_progress = timelines.pluck(:progress).compact
    goal_completion = weekly_goals.count > 0 ? (weekly_goals.select { |wg| wg.weekly_slots.any? }.count.to_f / weekly_goals.count * 100) : 0

    all_scores = assignment_scores + timeline_progress
    average_score = all_scores.any? ? (all_scores.sum / all_scores.size) : nil

    {
      assignment_scores: assignment_scores,
      timeline_progress: timeline_progress,
      goal_completion: goal_completion,
      average_score: average_score,
      data_points: all_scores.size
    }
  end

  def calculate_correlation(attendance_data, performance_data)
    return 0 if attendance_data[:weekly_rates].size < 3 || performance_data[:data_points] < 3

    # Use weekly attendance rates and try to match with weekly performance
    # For simplicity, we'll use average attendance rate vs average performance
    # A more sophisticated approach would match weekly data points

    attendance_rate = attendance_data[:attendance_rate]
    performance_score = performance_data[:average_score]

    return 0 if performance_score.nil?

    # Simple correlation: if attendance is high and performance is high = positive
    # If attendance is low and performance is low = positive
    # If attendance is high and performance is low = negative
    # If attendance is low and performance is high = negative

    # Normalize to 0-1 scale
    att_norm = attendance_rate / 100.0
    perf_norm = performance_score / 100.0

    # Calculate correlation coefficient (simplified Pearson correlation)
    # For two data points, we compare their relationship
    diff = (att_norm - 0.5).abs - (perf_norm - 0.5).abs
    correlation = 1.0 - (diff.abs * 2)

    # Adjust based on actual relationship
    if (att_norm > 0.5 && perf_norm > 0.5) || (att_norm < 0.5 && perf_norm < 0.5)
      correlation = correlation.abs
    else
      correlation = -correlation.abs
    end

    correlation.round(2)
  end

  def calculate_weekly_attendance_rates(learner)
    return [] if learner.nil?

    weeks = Week.where("start_date >= ? AND end_date <= ?", @start_date, @end_date).order(:start_date)
    rates = []

    weeks.each do |week|
      attendances = learner.attendances.where(attendance_date: week.start_date..week.end_date)
      week_days = business_days_in_range(week.start_date, week.end_date)
      next if week_days.zero?

      present_days = attendances.where(absence: 'Present').count
      rate = (present_days.to_f / week_days * 100).round(1)
      rates << rate
    end

    rates
  end

  def calculate_trend(weekly_rates)
    return 0 if weekly_rates.size < 2

    # Simple linear trend: compare first half vs second half
    mid_point = weekly_rates.size / 2
    first_half_avg = weekly_rates[0...mid_point].sum / mid_point.to_f
    second_half_avg = weekly_rates[mid_point..-1].sum / (weekly_rates.size - mid_point).to_f

    (second_half_avg - first_half_avg).round(1)
  end

  def calculate_average_attendance_rate(learners)
    return 0 if learners.empty?

    total_rate = learners.sum { |learner| calculate_attendance_rate(learner) }
    (total_rate / learners.count).round(1)
  end

  def learners_below_threshold(learners, threshold: 70)
    learners.select { |learner| calculate_attendance_rate(learner) < threshold }
  end

  def strong_correlation_count
    correlations = attendance_performance_correlation
    correlations.select { |c| c[:correlation].abs > 0.5 }.count
  end

  def business_days_in_range(start_date, end_date)
    # Ensure both are Date objects
    start_date = start_date.to_date if start_date.respond_to?(:to_date)
    end_date = end_date.to_date if end_date.respond_to?(:to_date)

    (start_date..end_date).count { |date| !date.saturday? && !date.sunday? }
  end

  # Calculate average hours spent at hub per day for a learner
  def calculate_avg_hours_at_hub(learner)
    return 0 if learner.nil?

    attendances = learner.attendances
      .where(attendance_date: @start_date..@end_date)
      .where(absence: 'Present')
      .where.not(start_time: nil, end_time: nil)

    return 0 if attendances.empty?

    total_hours = 0.0
    valid_days = 0

    attendances.each do |attendance|
      next if attendance.start_time.nil? || attendance.end_time.nil?

      # Combine date with time to create proper datetime for calculation
      start_datetime = Time.zone.parse("#{attendance.attendance_date} #{attendance.start_time.strftime('%H:%M:%S')}")
      end_datetime = Time.zone.parse("#{attendance.attendance_date} #{attendance.end_time.strftime('%H:%M:%S')}")

      # Handle case where end_time might be on the next day (if someone stays past midnight)
      if end_datetime < start_datetime
        # End time is on next day, add 24 hours
        end_datetime += 1.day
      end

      # Calculate difference in hours
      hours = (end_datetime - start_datetime) / 3600.0

      total_hours += hours
      valid_days += 1
    end

    return 0 if valid_days.zero?

    (total_hours / valid_days).round(2)
  end

  # Calculate average hours at hub across all learners
  def calculate_average_hours_at_hub(learners)
    return 0 if learners.empty?

    total_hours = learners.sum { |learner| calculate_avg_hours_at_hub(learner) }
    (total_hours / learners.count).round(2)
  end
end
