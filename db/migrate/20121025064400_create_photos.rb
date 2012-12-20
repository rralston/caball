class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :image
      t.string :description
      t.string :content_type
      t.integer :file_size
      t.datetime :updated_at
      t.references :imageable, :polymorphic => true
      t.timestamps
    end
  end
end