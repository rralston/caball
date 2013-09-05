class AddOriginalDimensionsToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :original_width, :integer
    add_column :photos, :original_height, :integer
  end
end
