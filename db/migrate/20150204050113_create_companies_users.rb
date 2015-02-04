class CreateCompaniesUsers < ActiveRecord::Migration
  def change
    create_table :companies_users do |t|
      t.references :company, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
