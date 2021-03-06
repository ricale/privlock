class HomeController < ApplicationController
  before_action :load_categories
  before_action :set_new_comment, except: :category_writings

  # GET /
  def index
    per_page = @setting.number_of_writing
    @writings = Writing.order(created_at: :desc).page(params[:page]).per(per_page)
  end

  # GET /1
  def show
    @writing = Writing.find(params[:id])
  end

  # GET /categories/1
  def category_writings
    writings = Writing.in_category_tree(params[:category_id])

    @writings = writings.order(created_at: :desc).page(params[:page]).per(30)
    @writing_count = writings.count

    @category = Category.find(params[:category_id])
  end




  private

  def load_categories
    @categories = Category.high_categories(1)
  end

  def set_new_comment
    @comment = Comment.new
  end

end
