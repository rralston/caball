class AddGuildsColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :guild, :string
    add_column :users, :guild_present, :boolean, :default => false
  end
end
