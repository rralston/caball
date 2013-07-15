class AddApprovedColumnToRoleApplications < ActiveRecord::Migration
  def change
    add_column :role_applications, :approved, :boolean, :default => false
  end
end
