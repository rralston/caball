class CreateEventsTable < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :user
      t.string :title
      t.text :description
      t.string :website
      t.string :location
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
    add_index :events, [:user_id]
  end
end
