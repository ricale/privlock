class CreateCcls < ActiveRecord::Migration
  def change
    create_table :ccls do |t|
      t.string :name,       null: false
      t.string :url,        null: false
      t.text :description

      t.timestamps
    end
  end
end
