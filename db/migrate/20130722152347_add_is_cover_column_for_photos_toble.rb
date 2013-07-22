class AddIsCoverColumnForPhotosToble < ActiveRecord::Migration
  def change
    add_column :photos, :is_cover, :boolean, :default => false
  end
end
