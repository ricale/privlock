class AdminController < ApplicationController

  # GET /admin/general
  def general
    @setting = Setting.active_setting

    @tab = "general"
  end

  # GET /admin/categories
  def categories
    @categories = Category.hierarchy_categories

    @parents = Category.family_categories(Category.root.id)

    @new_category = Category.new

    @tab = "categories"
  end
end
