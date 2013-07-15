class AddMessageColumnToRoleApplications < ActiveRecord::Migration
  def change
    add_column :role_applications, :message, :text
  end
end
