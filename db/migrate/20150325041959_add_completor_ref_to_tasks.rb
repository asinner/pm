class AddCompletorRefToTasks < ActiveRecord::Migration
  def change
    add_reference :tasks, :completor, index: true
  end
end
