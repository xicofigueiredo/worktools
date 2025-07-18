module ExamFinancesHelper
  def calculate_total_cost(exam_enrolls)
    total_cost = 0
    exam_enrolls.each do |enroll|
      portugal = enroll.timeline.user.users_hubs.where(main: true).first.hub.country == "Portugal"
      sa = enroll.timeline.user.users_hubs.where(main: true).first.hub.country == "South Africa"
      if enroll.qualification == "IGCSE"
        if portugal
          total_cost += 200
        elsif sa
          total_cost += 4000
        end
      elsif enroll.qualification == "A Level" && (enroll.specific_papers == "" || enroll.specific_papers == nil)
        if portugal
          total_cost += 300
        elsif sa
          total_cost += 6000
        end
      elsif enroll.qualification == "AS" && (enroll.specific_papers == "" || enroll.specific_papers == nil)
        if portugal
          total_cost += 200
        elsif sa
          total_cost += 4000
        end
      elsif enroll.qualification == "A2" && (enroll.specific_papers == "" || enroll.specific_papers == nil)
        if portugal
          total_cost += 200
        elsif sa
          total_cost += 4000
        end
      elsif enroll.specific_papers != nil && enroll.specific_papers != ""
        total_cost += enroll.paper1_cost if enroll.paper1 != nil && enroll.paper1 != ""
        total_cost += enroll.paper2_cost if enroll.paper2 != nil && enroll.paper2 != ""
        total_cost += enroll.paper3_cost if enroll.paper3 != nil && enroll.paper3 != ""
        total_cost += enroll.paper4_cost if enroll.paper4 != nil && enroll.paper4 != ""
        total_cost += enroll.paper5_cost if enroll.paper5 != nil && enroll.paper5 != ""
      end
    end
    total_cost
  end
end
