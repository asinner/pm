class AddStripPlanIdToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :stripe_plan_id, :string
  end
end
