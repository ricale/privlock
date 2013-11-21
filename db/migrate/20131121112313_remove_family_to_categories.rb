class RemoveFamilyToCategories < ActiveRecord::Migration
  def change
    remove_column :categories, :family
  end
end
