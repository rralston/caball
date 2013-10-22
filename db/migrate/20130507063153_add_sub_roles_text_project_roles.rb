class AddSubRolesTextProjectRoles < ActiveRecord::Migration
  def up
    change_table :roles do |t|
          t.string :subrole
  end
end

  def down
    remove_column :roles, :subrole
  end
end