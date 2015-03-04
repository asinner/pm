class RemoveCreateRefFromDiscussions < ActiveRecord::Migration
  def change
    remove_reference :discussions, :creator
  end
end
