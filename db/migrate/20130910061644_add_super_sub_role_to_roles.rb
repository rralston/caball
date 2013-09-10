class AddSuperSubRoleToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :super_subrole, :string
  end
end
