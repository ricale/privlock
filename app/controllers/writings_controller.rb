class WritingsController < ApplicationController
  before_action :set_writing, only: [:show, :edit, :update, :destroy]
  before_action :set_categories, only: [:new, :edit]

  def index
    @writings = Writing.all
  end

  def show
  end

  def new
    @writing = Writing.new
  end

  def edit
  end

  def create
    @writing = Writing.new(writing_params)

    respond_to do |format|
      if @writing.save
        format.html { redirect_to @writing, notice: 'Writing was successfully created.' }
      else
        format.html { render action: 'new', alert: 'fail' }
      end
    end
  end

  def update
    respond_to do |format|
      if @writing.update(writing_params)
        format.html { redirect_to @writing, notice: 'Writing was successfully updated.' }
      else
        format.html { render action: 'edit', alert: 'fail' }
      end
    end
  end

  def destroy
    @writing.destroy
    respond_to do |format|
      format.html { redirect_to writings_url }
    end
  end

  private

  def set_writing
    @writing = Writing.find(params[:id])
  end

  def set_categories
    @categories = Category.hierarchy_categories(:all)
  end

  def writing_params
    params.require(:writing).permit(:title, :content, :category_id)
  end
end
