module ApplicationHelper
  def valid_user?(user)
    !current_user.nil? && current_user == user
  end

  def time_to_string(datetime)
    datetime ? datetime.strftime("%Y%m%d%H%M%S") : "19700101"
  end

  def string_to_time(string)
    Time.parse string
  end
end
