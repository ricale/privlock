class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.boolean :active
      t.string  :title,             null: false
      t.integer :number_of_writing, null: false

      t.timestamps
    end
  end
end
