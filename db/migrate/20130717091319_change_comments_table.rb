class ChangeCommentsTable < ActiveRecord::Migration
  def up
    change_table(:comments) do |t|
      t.remove :project_id

      t.references :commentable
      t.string :commentable_type
    end
    add_index :comments, :commentable_id
  end

  def down
    change_table(:comments) do |t|
      t.references :project

      t.remove :commentable_id
      t.remove :commentable_type
    end
    add_index :comments, :project_id
  end
end
