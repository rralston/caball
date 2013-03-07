class CreateProjectUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.text :content
      t.belongs_to :user
      t.belongs_to :project

      t.timestamps
    end
    add_index :updates, :user_id
    add_index :updates, :project_id
  end
end