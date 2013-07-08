class RenameProjectTypesField < ActiveRecord::Migration
  def up
    rename_column :projects, :type, :is_type
  end

  def down
    rename_column :projects, :is_type, :type
  end
end
