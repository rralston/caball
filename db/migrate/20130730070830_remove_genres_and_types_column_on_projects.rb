class RemoveGenresAndTypesColumnOnProjects < ActiveRecord::Migration
  def up
    remove_column :projects, :genre
    remove_column :projects, :is_type
  end

  def down
    add_column :projects, :genre, :string
    add_column :projects, :is_type, :string
  end
end
