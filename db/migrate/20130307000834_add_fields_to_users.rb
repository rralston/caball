class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gender, :string
    add_column :users, :imdb_url, :string
    add_column :users, :headline, :text
    add_column :users, :featured, :boolean
  end
end
