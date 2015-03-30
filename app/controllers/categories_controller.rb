class CategoriesController < ApplicationController
  before_action :authenticate_user!

  before_action :admin_tab_name
  before_action :set_category, except: [:create]


  # POST /categories
  def create
    @category = Category.new(category_params)
    @category.save!

    redirect_to admin_categories_path, notice: 'Category was successfully created.'
  rescue => e
    redirect_to admin_categories_path, alert: e.to_s
  end

  # PATCH/PUT /categories/1
  def update
    @category.update!(category_params)

    redirect_to admin_categories_path, notice: 'Category was successfully updated.'
  rescue => e
    redirect_to admin_categories_path, alert: e.to_s
  end

  # PATCH /categories/1/up
  def up
    @category.up

    redirect_to admin_categories_path, notice: 'Category was successfully updated.'
  rescue => e
    redirect_to admin_categories_path, alert: e.to_s
  end

  # PATCH /categories/1/down
  def down
    @category.down

    redirect_to admin_categories_path, notice: 'Category was successfully updated.'
  rescue => e
    redirect_to admin_categories_path, alert: e.to_s
  end

  # DELETE /categories/1
  def destroy
    @category.destroy

    redirect_to admin_categories_path, notice: 'Category was successfully removed.'
  rescue => e
    redirect_to admin_categories_path, alert: e.to_s
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
