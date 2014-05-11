class AddFamilyToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :family, :integer
  end
end
