class AddCclIdAndAuthorNameAndAuthorEmailToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :ccl_id,       :integer
    add_column :settings, :author_name,  :string
    add_column :settings, :author_email, :string
  end
end
