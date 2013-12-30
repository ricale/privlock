module WritingsHelper
  def get_chained_categories(category, top_ancestor = :root, except_top = false)
    category.ancestors_and_me(top_ancestor, except_top).map { |category|
      link_to category.name, category_writings_path(category)
    }.join("/").html_safe
  end

  def get_formatted_time(datetime)
    datetime.in_time_zone('Seoul').strftime("%Y.%m.%d %H:%M:%S")
  end

  def get_formatted_date(datetime)
    datetime.in_time_zone('Seoul').strftime("%Y.%m.%d")
  end
end
