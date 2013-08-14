class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :famaily
      t.integer :depth
      t.integer :order

      t.timestamps
    end
  end
end
