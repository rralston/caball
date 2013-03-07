class AddFieldsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :status, :string
    add_column :projects, :featured, :boolean
    add_column :projects, :type, :string
    add_column :projects, :genre, :string
    add_column :projects, :location, :string
    add_column :projects,  :latitude, :float
    add_column :projects,  :longitude, :float
  end
end
