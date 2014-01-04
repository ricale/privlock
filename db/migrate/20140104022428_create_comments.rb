class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :writing_id,   null: false
      t.string  :email
      t.string  :name
      t.string  :password_hash
      t.integer :user_id
      t.text    :content,      null: false

      t.timestamps
    end
  end
end
