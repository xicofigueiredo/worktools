class HubsController < ApplicationController
  def show
    @hub = Hub.find(params[:id])
    hub_id = @hub.id.to_i

    # 1) user ids that belong to this hub as main
    hub_user_ids = UsersHub.where(hub_id: hub_id, main: true).distinct.pluck(:user_id)

    # 2) Get all learner infos for hub users, filter by status = "Active"
    @active_learners_scope = LearnerInfo.where(user_id: hub_user_ids, status: 'Active').includes(:user)

    # basic totals
    @total_active_learners = @active_learners_scope.count

    # capacity
    if @hub.capacity.present? && @hub.capacity.positive?
      @capacity_total = @hub.capacity
      @free_spots = [@hub.capacity - @total_active_learners, 0].max
      @capacity_pct = ((@total_active_learners.to_f / @hub.capacity.to_f) * 100).round(1)
    else
      @capacity_total = nil
      @free_spots = nil
      @capacity_pct = nil
    end

    # age calculations
    birthdates = @active_learners_scope.where.not(birthdate: nil).pluck(:birthdate)
    today = Date.current
    ages = birthdates.map do |bd|
      age = today.year - bd.year
      age -= 1 if today.month < bd.month || (today.month == bd.month && today.day < bd.day)
      age
    end

    @age_average = ages.any? ? (ages.sum.to_f / ages.size).round(1) : nil

    # age buckets
    @age_bucket_ranges = {
      '11-13' => 0,
      '14-15' => 0,
      '16-17' => 0,
      '18+'   => 0
    }
    ages.each do |a|
      case a
      when 11..13 then @age_bucket_ranges['11-13'] += 1
      when 14..15 then @age_bucket_ranges['14-15'] += 1
      when 16..17 then @age_bucket_ranges['16-17'] += 1
      else            @age_bucket_ranges['18+']   += 1
      end
    end

    # Programme / curriculum / grade distributions (DB grouped counts)
    @programme_distribution  = @active_learners_scope.group(:programme).order(Arel.sql('count_all DESC')).count
    @curriculum_distribution = @active_learners_scope.group(:curriculum_course_option).order(Arel.sql('count_all DESC')).count
    @grade_distribution      = @active_learners_scope.group(:grade_year).order(Arel.sql('count_all DESC')).count

    # Gender distribution (normalize keys)
    @gender_distribution = @active_learners_scope.group(:gender).count.transform_keys { |k| k.presence || 'Unknown' }

    # Nationality counts (for bar graph)
    @nationality_counts = @active_learners_scope.group(:nationality).order(Arel.sql('count_all DESC')).count
    # convert to Chartkick-friendly array (labels sorted descending)
    @nationality_data = @nationality_counts.map { |nat, cnt| [nat.presence || 'Unknown', cnt] }

    # curriculum data for donut/pie (Chartkick-friendly)
    @curriculum_data = @curriculum_distribution.map { |k, v| [k.presence || 'Unknown', v] }

    # list of LCs for the hub (those with role 'lc' and fewer than 3 hubs)
    @lcs = @hub.users.where(role: 'lc')
                    .left_joins(:hubs)
                    .where(deactivate: [false, nil])
                    .select('users.*, COUNT(hubs.id) AS hubs_count')
                    .group('users.id')
                    .having('COUNT(hubs.id) < ?', 3)

    # a sample of learners to show in a table if desired
    @learners_sample = @active_learners_scope
                        .select(:id, :full_name, :birthdate, :programme, :curriculum_course_option, :grade_year, :student_number)
                        .order(:full_name)
                        .limit(200)
  end
end
