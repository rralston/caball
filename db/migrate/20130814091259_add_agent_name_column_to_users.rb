class AddAgentNameColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :agent_present, :boolean, :default => false
    add_column :users, :agent_name, :string
  end
end
