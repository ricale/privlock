module ApplicationHelper
  def valid_user?(user)
    !current_user.nil? && current_user == user
  end

  def icon_menu_button(icon_class_name, path, options = nil, btn_class = nil)
    options   ||= {}
    btn_class ||= "btn-xs btn-default"

    method = options[:method]
    data   = options[:data]

    if method.nil?
      link_to "<span class='glyphicon glyphicon-#{icon_class_name}'></span>".html_safe, path, data: data, class: "btn #{btn_class}"
    else
      link_to "<span class='glyphicon glyphicon-#{icon_class_name}'></span>".html_safe, path, method: method, data: data, class: "btn #{btn_class}"
    end
  end

  def icon_menu_link(icon_class_name, path, options = nil)
    options ||= {}

    method = options[:method] || "get"
    data   = options[:data]
    caption = options[:caption] || ""

    link_to "<span class='glyphicon glyphicon-#{icon_class_name}'></span> #{caption}".html_safe, path, method: method, data: data
  end

  def dead_link(*args)
    has_key = *args[2].has_key?(:class)
    if has_key
      *args[2][:class] = "#{args[2][:class]} dead_link"
    else
      *args[2][:class] = "dead_link"
    end

    link_to *args
  end
end
