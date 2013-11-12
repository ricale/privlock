class CategoriesController < ApplicationController
  before_action :set_category, only: [:update, :up, :down, :destroy]

  # GET /categories
  def index
    @categories = Category.hierarchy_categories(:all)

    @parents = {}
    @categories.each do |c|
      @parents[c.id] = categories_for_select_box(Category.hierarchy_categories(:all, [c.id]))
    end
  end

  # GET /categories/new
  def new
    @category = Category.new
    @parents = categories_for_select_box(Category.hierarchy_categories(:all))
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
        format.html { redirect_to action: 'index' }
      end
    end
  end

  def up
    respond_to do |format|
      if @category.up
        format.html { redirect_to categories_path, notice: 'Category was successfully updated.' }
      else
        format.html { redirect_to categories_path, alert: 'Impossible' }
      end
    end
  end

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
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url }
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
