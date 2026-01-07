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

    decimal_hours = seconds / 3600.0
    rounded_hours = (decimal_hours * 2).round / 2.0  # Round to nearest 0.5

    if rounded_hours == rounded_hours.to_i
      "#{rounded_hours.to_i}h"
    else
      "#{rounded_hours}h"
    end
  end

  def email_initials(email)
    return '?' if email.blank? || email == 'System'

    # Extract the part before @
    local_part = email.split('@').first

    # Get first letter only
    local_part[0].upcase
  end
end
