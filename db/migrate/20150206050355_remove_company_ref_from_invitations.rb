class RemoveCompanyRefFromInvitations < ActiveRecord::Migration
  def change
    remove_reference :invitations, :company
  end
end
