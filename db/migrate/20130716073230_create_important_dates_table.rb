class CreateImportantDatesTable < ActiveRecord::Migration
  def change
    create_table :important_dates do |t|
      t.references :important_dateable
      t.string :important_dateable_type
      t.string :description
      t.string :date_time

      t.timestamps
    end
    add_index :important_dates, [:important_dateable_id]
  end
end
