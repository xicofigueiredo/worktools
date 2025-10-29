module ApplicationHelper
  def field_disabled?(current_user)
    return false if current_user.role == 'admin'
    return true if ['cm', 'rm', 'edu'].include?(current_user.role)
    false
  end

  def role_icon(role)
    case role
    when 'admin'
      'fas fa-user-shield'
    when 'learner'
      'fas fa-graduation-cap'
    when 'lc'
      'fas fa-users'
    when 'cm'
      'fas fa-chalkboard-teacher'
    when 'exams'
      'fas fa-clipboard-list'
    when 'parent'
      'fas fa-home'
    else
      'fas fa-user'
    end
  end

  def format_time_spent(seconds)
    return "0h" if seconds.nil? || seconds == 0

    hours = seconds / 3600
    minutes = (seconds % 3600) / 60

    if hours > 0 && minutes > 0
      "#{hours}h #{minutes}m"
    elsif hours > 0
      "#{hours}h"
    else
      "#{minutes}m"
    end
  end
end
