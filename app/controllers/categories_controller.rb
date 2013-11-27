class CategoriesController < ApplicationController
  before_action :authenticate_user!

  before_action :set_category, only: [:show, :update, :up, :down, :destroy]

  # GET /categories
  def index
    @categories = Category.hierarchy_categories(:all)

    @parents = {}
    @categories.each do |c|
      @parents[c.id] = Category.hierarchy_categories(:all, [c.id])
    end

    @new_category = Category.new
    @new_parents  = Category.hierarchy_categories(:all)
  end




  # POST /categories
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_path, notice: 'Category was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /categories/1
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to categories_path, notice: 'Category was successfully updated.' }
      else
        format.html { redirect_to categories_path, alert: 'Impossible' }
      end
    end
  end

  # PATCH /categories/1/up
  def up
    respond_to do |format|
      if @category.up
        format.html { redirect_to categories_path, notice: 'Category was successfully updated.' }
      else
        format.html { redirect_to categories_path, alert: 'Impossible' }
      end
    end
  end

  # PATCH /categories/1/down
  def down
    respond_to do |format|
      if @category.down
        format.html { redirect_to categories_path, notice: 'Category was successfully updated.' }
      else
        format.html { redirect_to categories_path, alert: 'Impossible' }
      end
    end
  end

  # DELETE /categories/1
  def destroy
    respond_to do |format|
      if @category.destroy
        format.html { redirect_to categories_url, notice: 'Category was successfully removed.' }
      else
        format.html { redirect_to categories_url, alert: 'Impossible' }
      end
    end
  end




  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :parent_id)
  end
end
