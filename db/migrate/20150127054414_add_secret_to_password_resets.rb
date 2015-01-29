class AddSecretToPasswordResets < ActiveRecord::Migration
  def change
    add_column :password_resets, :secret, :string
  end
end
