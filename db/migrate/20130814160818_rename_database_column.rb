class RenameDatabaseColumn < ActiveRecord::Migration
  def up
  	rename_column :categories, :order, :orderby
  	rename_column :categories, :famaily, :family
  end

  def down
  	rename_column :categories, :orderby, :order
  	rename_column :categories, :family, :famaily
  end
end
