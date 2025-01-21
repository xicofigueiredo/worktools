class StaticController < ApplicationController
  skip_before_action :check_browser, only: [:unsupported_browser]

  def unsupported_browser
  end
end
