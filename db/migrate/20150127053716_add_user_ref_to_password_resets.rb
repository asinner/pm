class AddUserRefToPasswordResets < ActiveRecord::Migration
  def change
    add_reference :password_resets, :user, index: true
  end
end
