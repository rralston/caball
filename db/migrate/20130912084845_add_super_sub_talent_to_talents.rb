class AddSuperSubTalentToTalents < ActiveRecord::Migration
  def change
    add_column :talents, :super_sub_talent, :string
  end
end
