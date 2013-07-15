class AddExperienceToTalents < ActiveRecord::Migration
  def change
    add_column :talents, :experience, :string
  end
end
