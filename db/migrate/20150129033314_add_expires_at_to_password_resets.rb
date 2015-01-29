class AddExpiresAtToPasswordResets < ActiveRecord::Migration
  def change
    add_column :password_resets, :expires_at, :datetime
  end
end
