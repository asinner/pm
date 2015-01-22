class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :recipient
      t.references :company, index: true
      t.string :key
      t.datetime :deleted_at
      t.datetime :used_at

      t.timestamps
    end
  end
end
