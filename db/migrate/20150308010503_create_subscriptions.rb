class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :company, index: true
      t.references :plan, index: true

      t.timestamps
    end
  end
end
