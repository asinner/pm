class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :upload_limit

      t.timestamps
    end
  end
end
