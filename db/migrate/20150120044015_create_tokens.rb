class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :string
      t.references :user, index: true
      t.datetime :expires_at

      t.timestamps
    end
  end
end
