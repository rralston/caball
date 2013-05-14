class AddProducerThoughtstoProjects < ActiveRecord::Migration
  def up
    change_table :projects do |t|
          t.string :thoughts
    end
  end

  def down
    remove_column :projects, :thoughts
  end
end
