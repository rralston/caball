class AddFieldsToProjectTalents < ActiveRecord::Migration
  def change
    add_column :talents, :description2, :text
  end
end
