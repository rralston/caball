class CreateVideos < ActiveRecord::Migration
    def change
      create_table :videos do |t|
        t.string :url
        t.string :provider
        t.string :title
        t.text :description
        t.string :keywords
        t.integer :duration
        t.datetime :date
        t.string :thumbnail_small
        t.string :thumbnail_large
        t.string :embed_url
        t.string :embed_code
        t.datetime :video_updated_at
        t.references :videoable, :polymorphic => true
        t.timestamps
      end
    end
  end