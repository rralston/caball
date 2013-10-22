class AddRawUrlNameToUsersProjectEvents < ActiveRecord::Migration
  def up
    add_column :projects, :raw_url_name, :string
    add_column :events, :raw_url_name, :string
    add_column :users, :raw_url_name, :string
  end

  def down
    remove_column :projects, :raw_url_name
    remove_column :events, :raw_url_name
    remove_column :users, :raw_url_name
  end
end
