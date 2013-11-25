class AddSendNotificationMailsColumnOnUsers < ActiveRecord::Migration
  def change
    add_column :users, :send_notification_mails, :boolean, :default => true
  end
end
