class AddOriginalDimensionsForProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :original_width, :integer
    add_column :profiles, :original_height, :integer
  end
end
