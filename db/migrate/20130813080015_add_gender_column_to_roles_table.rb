class AddGenderColumnToRolesTable < ActiveRecord::Migration
  def change
    add_column :roles, :gender, :string, :default => 'male'
  end
end
