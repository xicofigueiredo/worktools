class HubsController < ApplicationController
  def show
    @hub = Hub.find(params[:id])

    hub_id = @hub.id.to_i

    active_learners = LearnerInfo.joins(:user)
                                 .joins(
                                   "INNER JOIN users_hubs uh ON uh.user_id = users.id " \
                                   "AND uh.hub_id = #{hub_id} AND uh.main = TRUE"
                                 )
                                 .where(users: { deactivate: false })

    # Basic counts
    @total_active_learners = active_learners.count

    # Age stats: compute in Ruby from birthdate
    birthdates = active_learners.where.not(birthdate: nil).pluck(:birthdate)
    today = Date.current

    ages = birthdates.map do |bd|
      age = today.year - bd.year
      age -= 1 if today.month < bd.month || (today.month == bd.month && today.day < bd.day)
      age
    end

    @age_average = ages.any? ? (ages.sum.to_f / ages.size).round(1) : nil
    @age_distribution = ages.group_by(&:itself).transform_values(&:count).sort.to_h

    # Programme / curriculum / grade distributions
    @programme_distribution  = active_learners.group(:programme).order(Arel.sql("count_all DESC")).count
    @curriculum_distribution = active_learners.group(:curriculum_course_option).order(Arel.sql("count_all DESC")).count
    @grade_distribution      = active_learners.group(:grade_year).order(Arel.sql("count_all DESC")).count

    # Capacity usage (if capacity present on hub)
    if @hub.capacity.present? && @hub.capacity.positive?
      @capacity_usage_count = @total_active_learners
      @capacity_percentage  = (@capacity_usage_count.to_f / @hub.capacity.to_f * 100).round(1)
    else
      @capacity_usage_count = @total_active_learners
      @capacity_percentage  = nil
    end

    # Bucketed age distribution
    @age_buckets = {
      '6-10' => 0,
      '11-15'=> 0,
      '16-18'=> 0,
      '19+'  => 0
    }
    ages.each do |a|
      case a
      when 6..10  then @age_buckets['6-10'] += 1
      when 11..15 then @age_buckets['11-15']+= 1
      when 16..18 then @age_buckets['16-18']+= 1
      else             @age_buckets['19+']  += 1
      end
    end
  end
end
