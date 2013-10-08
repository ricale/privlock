class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string  :name,            null: false
      t.string  :parent_id,       default: nil
      t.integer :family,          null: false, default: 0
      t.integer :depth,           null: false, default: 0
      t.integer :order_in_parent, null: false, default: 0

      t.timestamps
    end
  end
end
