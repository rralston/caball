class AddIsStartDateAndIsEndDateFieldsToImportantDates < ActiveRecord::Migration
  def change
    add_column :important_dates, :is_start_date, :boolean, :default => false
    add_column :important_dates, :is_end_date, :boolean, :default => false
  end
end
