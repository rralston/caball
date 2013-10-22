class RemoveExperienceColumnFromTalentsTable < ActiveRecord::Migration
  def up
    remove_column :talents, :experience
  end

  def down
    add_column :talents, :experience, :string
  end
end
