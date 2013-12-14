class HomeController < ApplicationController
  before_action :set_categories

  def index
    if params[:category_id]
      @writings = Category.find(params[:category_id]).descendants_writings.order(created_at: :desc).page(params[:page])
    else
      @writings = Writing.order(created_at: :desc).page(params[:page])
    end
  end

  def show
    @writing = Writing.find(params[:id])
  end




  private

  def set_categories
    @categories = Category.hierarchy_categories(:all)
  end

end
