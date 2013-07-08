class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.date :start
      t.date :end
      t.references :user
      t.timestamps
    end
  end
end