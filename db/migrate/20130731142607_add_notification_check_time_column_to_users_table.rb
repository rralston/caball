class AddNotificationCheckTimeColumnToUsersTable < ActiveRecord::Migration
  def change
    add_column :users, :notification_check_time, :datetime, :default => Time.now()
  end
end
