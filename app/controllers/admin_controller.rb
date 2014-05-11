class AdminController < ApplicationController
  def general
    @setting = Setting.active_setting

    @tab = "general"
  end

  def categories
    @categories = Category.hierarchy_categories

    @parents = {}
    @categories.each do |c|
      @parents[c.id] = Category.hierarchy_categories(:all, [c.id])
    end

    @new_category = Category.new
    @new_parents  = Category.hierarchy_categories

    @tab = "categories"
  end
end
