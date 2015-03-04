class AddAssignerRefToAssignments < ActiveRecord::Migration
  def change
    add_reference :assignments, :assigner, index: true
  end
end
