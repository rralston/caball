class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.datetime :start
      t.datetime :end
      t.references :user
      t.timestamps
    end
  end
end