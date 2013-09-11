class AddCharacteristicsToRole < ActiveRecord::Migration
  def change
    add_column :roles, :age, :string
    add_column :roles, :ethnicity, :string
    add_column :roles, :height, :string
    add_column :roles, :build, :string
    add_column :roles, :haircolor, :string
    add_column :roles, :cast_title, :string
  end
end
