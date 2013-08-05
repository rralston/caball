class AddIsMainColumnToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :is_main, :boolean, :default => false
  end
end
