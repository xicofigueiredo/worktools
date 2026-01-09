class HubsController < ApplicationController
  def show
    @hub = Hub.find(params[:id])

    # Use hub model methods for active learners
    @active_learners_scope = @hub.active_learners.includes(:user)
    @total_active_learners = @active_learners_scope.count

    # Use hub model methods for capacity
    capacity_info = @hub.capacity_info
    @capacity_total = capacity_info[:total]
    @free_spots = capacity_info[:free]
    @capacity_pct = capacity_info[:percentage]

    # Age calculations
    birthdates = @active_learners_scope.where.not(birthdate: nil).pluck(:birthdate)
    ages = calculate_ages(birthdates)

    @age_average = ages.any? ? (ages.sum.to_f / ages.size).round(1) : nil
    @age_bucket_ranges = group_ages_into_buckets(ages)

    # Distributions
    @programme_distribution  = @active_learners_scope.group(:programme).order(Arel.sql('count_all DESC')).count
    @curriculum_distribution = @active_learners_scope.group(:curriculum_course_option).order(Arel.sql('count_all DESC')).count
    @grade_distribution      = @active_learners_scope.group(:grade_year).order(Arel.sql('count_all DESC')).count
    @gender_distribution     = @active_learners_scope.group(:gender).count.transform_keys { |k| k.presence || 'Unknown' }

    # Charts data
    @nationality_counts = @active_learners_scope.group(:nationality).order(Arel.sql('count_all DESC')).count
    @nationality_data = @nationality_counts.map { |nat, cnt| [nat.presence || 'Unknown', cnt] }
    @curriculum_data = @curriculum_distribution.map { |k, v| [k.presence || 'Unknown', v] }

    # Use hub model method for LCs
    @lcs = @hub.learning_coaches_with_capacity(3)

    @regional_manager = @hub.respond_to?(:regional_manager) ? @hub.regional_manager : nil

    # Sample learners
    @learners_sample = @active_learners_scope
                        .select(:id, :full_name, :birthdate, :programme, :curriculum_course_option, :grade_year, :student_number)
                        .order(:full_name)
                        .limit(200)
  end

  def calendar
    @hub = Hub.find(params[:id])
    @year = params[:year] ? params[:year].to_i : Date.current.year
    @prev_year = @year - 1
    @next_year = @year + 1

    hub_tz = HubVisit::COUNTRY_TIMEZONES[@hub.country] || 'UTC'

    Time.use_zone(hub_tz) do
    # Call Service to get data
      service = CalendarDataService.new(year: @year, hub: @hub, include_visits: true)
      data = service.call

      @holidays_by_date = data[:holidays]
      @blocked_by_date  = data[:blocked]
      @mandatory_leaves = data[:mandatory]
      @visits_by_date   = data[:visits]
    end

    @new_blocked_period = BlockedPeriod.new
  end

  private

  def calculate_ages(birthdates)
    today = Date.current
    birthdates.map do |bd|
      age = today.year - bd.year
      age -= 1 if today.month < bd.month || (today.month == bd.month && today.day < bd.day)
      age
    end
  end

  def group_ages_into_buckets(ages)
    buckets = {
      '11-13' => 0,
      '14-15' => 0,
      '16-17' => 0,
      '18+'   => 0
    }

    ages.each do |a|
      case a
      when 11..13 then buckets['11-13'] += 1
      when 14..15 then buckets['14-15'] += 1
      when 16..17 then buckets['16-17'] += 1
      else            buckets['18+']   += 1
      end
    end

    buckets
  end
end
