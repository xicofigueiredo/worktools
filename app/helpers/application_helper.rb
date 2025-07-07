module ApplicationHelper
  def field_disabled?(current_user)
    return false if current_user.role == 'admin'
    return true if ['cm', 'rm', 'edu'].include?(current_user.role)
    false
  end
end
