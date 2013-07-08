class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.text :content
      t.belongs_to :user

      t.timestamps
    end
    add_index :blogs, :user_id
  end
end
