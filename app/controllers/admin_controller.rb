class AdminController < ApplicationController
  before_action :require_login, :authorize

  def authorize
    raise AccessGranted::AccessDenied
  end

end
