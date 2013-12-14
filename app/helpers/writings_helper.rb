module WritingsHelper
  def get_chained_categories(category)
    category.ancestors_and_me.map { |category|
      link_to category.name, category_writings_path(category)
    }.join("/").html_safe
  end

  def get_formatted_time(datetime)
    datetime.strftime("%Y.%m.%d %H:%M:%S")
  end
end
