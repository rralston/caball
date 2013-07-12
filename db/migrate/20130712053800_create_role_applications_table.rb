class CreateRoleApplicationsTable < ActiveRecord::Migration
  def change
    create_table :role_applications do |t|
      t.references :user
      t.references :role

      t.timestamps
    end
    add_index :role_applications, [:user_id, :role_id]
  end
end
