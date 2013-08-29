class AddAgentCompanyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :managing_company, :string
  end
end
