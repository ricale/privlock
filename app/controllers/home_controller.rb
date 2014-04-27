class HomeController < ApplicationController
  before_action :set_categories
  before_action :set_new_comment, except: :category_writings

  def index
    @writings = Writing.order(created_at: :desc).page(params[:page])
  end

  def show
    @writing = Writing.find(params[:id])
  end

  def category_writings
    writings = Writing.in_category_tree(params[:category_id])

    @writings = writings.order(created_at: :desc).page(params[:page]).per(30)

    @writing_count = writings.count
    @category_name = Category.find(params[:category_id]).name
  end




  private

  def set_categories
    @categories = Category.high_categories(1)
  end

  def set_new_comment
    @comment = Comment.new
  end

end
