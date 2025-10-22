class CustomFailure < Devise::FailureApp
  def redirect_url
    if warden_message.in?([:parent_access_denied, :learner_access_denied])
      new_user_session_url
    else
      super
    end
  end

  def respond
    if http_auth?
      http_auth
    else
      case warden_message
      when :parent_access_denied
        set_flash_message! :alert, :parent_access_denied
      when :learner_access_denied
        set_flash_message! :alert, :learner_access_denied
      end
      redirect
    end
  end
end
