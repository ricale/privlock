class HomeController < ApplicationController
  before_action :set_categories

  def index
    @writings = Writing.order(created_at: :desc).page(params[:page])
  end

  def show
    @writing = Writing.find(params[:id])
  end

  def category_writings
    writings = Category.find(params[:category_id]).descendants_writings

    @writings = writings.order(created_at: :desc).page(params[:page]).per(30)
    @count    = writings.count
    @category = Category.find(params[:category_id])
  end




  private

  def set_categories
    @categories = Category.hierarchy_categories(:all)
  end

end
