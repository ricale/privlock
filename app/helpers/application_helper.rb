module ApplicationHelper
  def valid_user?(user)
    !current_user.nil? && current_user == user
  end
end
