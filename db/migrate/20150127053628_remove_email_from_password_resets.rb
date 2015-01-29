class RemoveEmailFromPasswordResets < ActiveRecord::Migration
  def change
    remove_column :password_resets, :email
  end
end
