class RenameDescription2AsSynopsisOnTalentsTable < ActiveRecord::Migration
  def up
    rename_column :talents, :description2, :synopsis
  end

  def down
    rename_column :talents, :synopsis, :description2
  end
end
