class AddSubscriptionStatusToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :subscription_status, :string
  end
end
