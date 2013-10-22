class AddDateAndTimeColumnsToImportantDate < ActiveRecord::Migration
  def change
    add_column :important_dates, :date, :string
    add_column :important_dates, :time_string, :string
  end
end
