class CategoriesController < ApplicationController
  before_action :authenticate_user!

  before_action :admin_tab_name
  before_action :set_category, except: [:create]


  # POST /categories
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to admin_categories_path, notice: 'Category was successfully created.' }
      else
        format.html { redirect_to admin_categories_path, alert: 'Category was not created.' }
      end
    end
  end

  # PATCH/PUT /categories/1
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to admin_categories_path, notice: 'Category was successfully updated.' }
      else
        format.html { redirect_to admin_categories_path, alert: 'Category was not updated.' }
      end
    end
  end

  # PATCH /categories/1/up
  def up
    respond_to do |format|
      if @category.up
        format.html { redirect_to admin_categories_path, notice: 'Category was successfully updated.' }
      else
        format.html { redirect_to admin_categories_path, alert: 'Impossible' }
      end
    end
  end

  # PATCH /categories/1/down
  def down
    puts params.inspect
    respond_to do |format|
      if @category.down
        format.html { redirect_to admin_categories_path, notice: 'Category was successfully updated.' }
      else
        format.html { redirect_to admin_categories_path, alert: 'Impossible' }
      end
    end
  end

  # DELETE /categories/1
  def destroy
    respond_to do |format|
      if @category.destroy
        format.html { redirect_to admin_categories_path, notice: 'Category was successfully removed.' }
      else
        format.html { redirect_to admin_categories_path, alert: 'Impossible' }
      end
    end
  end




  private

  def admin_tab_name
    @tab = "categories"
  end

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :parent_id)
  end
end
