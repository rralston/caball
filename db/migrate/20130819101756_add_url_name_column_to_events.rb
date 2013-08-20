class AddUrlNameColumnToEvents < ActiveRecord::Migration
  def change
    add_column :events, :url_name, :string
  end
end
