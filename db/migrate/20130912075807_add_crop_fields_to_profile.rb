class AddCropFieldsToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :crop_x, :integer
    add_column :profiles, :crop_y, :integer
    add_column :profiles, :crop_w, :integer
    add_column :profiles, :crop_h, :integer
  end
end
