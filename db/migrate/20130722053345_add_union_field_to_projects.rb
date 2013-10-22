class AddUnionFieldToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :union, :string
  end
end
