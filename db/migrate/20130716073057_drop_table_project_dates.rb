class DropTableProjectDates < ActiveRecord::Migration
  def up
    drop_table :project_dates
  end

  def down
    create_table :project_dates do |t|
      t.references :project
      t.string :description
      t.string :date_time

      t.timestamps
    end
    add_index :project_dates, [:project_id]
  end
end
