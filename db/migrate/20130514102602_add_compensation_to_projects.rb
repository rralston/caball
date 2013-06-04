class AddCompensationToProjects < ActiveRecord::Migration
    def up
      change_table :projects do |t|
            t.string :compensation
    end
  end
  
  def down
    remove_column :projects, :compensation
  end
end
    
