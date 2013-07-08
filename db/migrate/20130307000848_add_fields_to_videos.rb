class AddFieldsToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :imdb, :string
    add_column :videos, :primary, :boolean
  end
end
