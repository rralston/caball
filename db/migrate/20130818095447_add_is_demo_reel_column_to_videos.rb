class AddIsDemoReelColumnToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :is_demo_reel, :boolean, :default => false
  end
end
