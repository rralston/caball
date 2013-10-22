class AddCropFieldsToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :crop_x, :integer
    add_column :photos, :crop_y, :integer
    add_column :photos, :crop_w, :integer
    add_column :photos, :crop_h, :integer
  end
end
