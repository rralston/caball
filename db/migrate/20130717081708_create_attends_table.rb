class CreateAttendsTable < ActiveRecord::Migration
  def change
    create_table :attends do |t|
      t.references :attendable
      t.string :attendable_type
      t.references :user

      t.timestamps
    end
    add_index :attends, [:user_id, :attendable_id]
  end
end
