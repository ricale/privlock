class CategoriesController < ApplicationController
  before_action :set_category, only: [:edit, :update, :destroy]

  # GET /categories
  def index
    @categories = Category.hierarchy_categories(:all)

    @parents = {}
    @categories.each do |c|
      @parents[c.id] = parents_for_select_box(Category.hierarchy_categories(:all, [c.id]))
    end
  end

  # GET /categories/new
  def new
    @category = Category.new
    @parents = parents_for_select_box(Category.all)
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
        format.html { render action: 'index' }
      end
    end
  end

  def up
    respond_to do |format|
      if @category.up
        format.html { redirect_to categories_path, notice: 'Category was successfully updated.' }
      else
        format.html { render action: 'index' }
      end
    end
  end

  def down
    respond_to do |format|
      if @category.down
        format.html { redirect_to categories_path, notice: 'Category was successfully updated.' }
      else
        format.html { render action: 'index' }
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
  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def category_params
    params.require(:category).permit(:name, :parent_id, :depth, :order_in_parent)
  end

  def parents_for_select_box(parent_categories)
    [["none", nil]].concat(parent_categories.map do |parent|
      [parent.name, parent.id]
    end)
  end
end
