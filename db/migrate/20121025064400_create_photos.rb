class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :image
      t.string :file_name
      t.string :content_type
      t.integer :file_size
      t.datetime :updated_at
      t.references :user
      t.timestamps
    end
  end
end