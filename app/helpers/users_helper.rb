module UsersHelper
  def user_role_display(user)
    case user.role
    when 'admin'
      'Admin'
    when 'lc'
      'Learning Coach'
    when 'learner'
      'Learner'
    else
      'Unknown Role'
    end
  end
end
