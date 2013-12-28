module WritingsHelper
  def get_chained_categories(category, first_ancestor = :root, except_itself = false)
    if except_itself
      category.ancestors(first_ancestor).map { |category|
        link_to category.name, category_writings_path(category)
      }.join("/").html_safe
    else
      category.ancestors_and_me(first_ancestor).map { |category|
        link_to category.name, category_writings_path(category)
      }.join("/").html_safe
    end
  end

  def get_formatted_time(datetime)
    datetime.in_time_zone('Seoul').strftime("%Y.%m.%d %H:%M:%S")
  end

  def get_formatted_date(datetime)
    datetime.in_time_zone('Seoul').strftime("%Y.%m.%d")
  end
end
