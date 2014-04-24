module ApplicationHelper
  def valid_user?(user)
    !current_user.nil? && current_user == user
  end

  def icon_menu_button(icon_class_name, path, options = nil, btn_class = nil)
    options   ||= {}
    btn_class ||= "btn-xs btn-default"

    method = options[:method]
    data   = options[:data]

    link_to "<span class='glyphicon glyphicon-#{icon_class_name}'></span>".html_safe, path, method: method, data: data, class: "btn #{btn_class}"
  end

  def icon_menu_link(icon_class_name, path, options = nil)
    options ||= {}

    method = options[:method] || "get"
    data   = options[:data]

    link_to "<span class='glyphicon glyphicon-#{icon_class_name}'></span>".html_safe, path, method: method, data: data
  end
end
