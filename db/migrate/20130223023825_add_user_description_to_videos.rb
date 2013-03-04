class AddUserDescriptionToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :user_description, :text
  end
end
