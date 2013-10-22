class AddSubTypeToTalents < ActiveRecord::Migration
  def change
    add_column :talents, :sub_talent, :string
  end
end
