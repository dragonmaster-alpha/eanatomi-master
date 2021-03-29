class AdminAccess
  def self.matches?(request)
    current_user = request.env[:clearance].current_user
    current_user&.admin?
  end
end
