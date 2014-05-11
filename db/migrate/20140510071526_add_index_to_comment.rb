class AddIndexToComment < ActiveRecord::Migration
  def change
    add_index :comments, :writing_id
  end
end
