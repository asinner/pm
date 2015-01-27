class AddStripeCustomerIdToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :stripe_customer_id, :string
  end
end
