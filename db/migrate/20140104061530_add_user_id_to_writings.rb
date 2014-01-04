class AddUserIdToWritings < ActiveRecord::Migration
  def change
    add_column :writings, :user_id, :integer, null: false
  end
end
