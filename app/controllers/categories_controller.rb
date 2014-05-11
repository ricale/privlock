class CategoriesController < ApplicationController
  before_action :authenticate_user!

  before_action :admin_tab_name
  before_action :set_category, except: [:create]


  # POST /categories
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      begin
        @category.save!

        format.html { redirect_to admin_categories_path, notice: 'Category was successfully created.' }
      rescue => e
        format.html { redirect_to admin_categories_path, alert: e.to_s }
      end
    end
  end

  # PATCH/PUT /categories/1
  def update
    respond_to do |format|
      begin
        @category.update!(category_params)

        format.html { redirect_to admin_categories_path, notice: 'Category was successfully updated.' }
      rescue => e
        format.html { redirect_to admin_categories_path, alert: e.to_s }
      end
    end
  end

  # PATCH /categories/1/up
  def up
    respond_to do |format|
      begin
        @category.up

        format.html { redirect_to admin_categories_path, notice: 'Category was successfully updated.' }
      rescue => e
        format.html { redirect_to admin_categories_path, alert: e.to_s }
      end
    end
  end

  # PATCH /categories/1/down
  def down
    respond_to do |format|
      begin
        @category.down

        format.html { redirect_to admin_categories_path, notice: 'Category was successfully updated.' }
      rescue => e
        format.html { redirect_to admin_categories_path, alert: e.to_s }
      end
    end
  end

  # DELETE /categories/1
  def destroy
    respond_to do |format|
      begin
        @category.destroy

        format.html { redirect_to admin_categories_path, notice: 'Category was successfully removed.' }
      rescue => e
        format.html { redirect_to admin_categories_path, alert: e.to_s }
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
