class CreateWritings < ActiveRecord::Migration
  def change
    create_table :writings do |t|
      t.string :title
      t.text :content
      t.integer :category_id
      t.integer :user_id

      t.timestamps
    end
  end
end
