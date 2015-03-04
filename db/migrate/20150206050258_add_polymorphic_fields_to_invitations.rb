class AddPolymorphicFieldsToInvitations < ActiveRecord::Migration
  def change
    add_reference :invitations, :invitable, polymorphic: true, index: true
  end
end
