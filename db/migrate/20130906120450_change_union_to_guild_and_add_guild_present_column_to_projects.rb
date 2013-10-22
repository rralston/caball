class ChangeUnionToGuildAndAddGuildPresentColumnToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :union_present, :boolean, :default => false
  end
end
