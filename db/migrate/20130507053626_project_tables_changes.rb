class ProjectTablesChanges < ActiveRecord::Migration
  def up
    change_table :roles do |t|
          t.boolean :filled, :default => false
    end
  end

  def down
    remove_column :roles, :filled
  end
end