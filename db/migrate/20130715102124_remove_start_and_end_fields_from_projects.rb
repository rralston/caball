class RemoveStartAndEndFieldsFromProjects < ActiveRecord::Migration
  def up
    remove_column :projects, :start
    remove_column :projects, :end
  end

  def down
    add_column :projects, :start, :string
    add_column :projects, :end, :string
  end
end
