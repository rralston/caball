class AddManagerToRoleApplications < ActiveRecord::Migration
  def change
    add_column :role_applications, :manager, :boolean, :default => false
  end
end
