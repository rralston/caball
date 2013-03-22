class CreateProfilePhotos < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :image
      t.string :description
      t.string :content_type
      t.integer :file_size
      t.datetime :updated_at
      t.references :user 
      t.timestamps
    end
  end
end
