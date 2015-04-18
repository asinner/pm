class AddUncompletorRefToTasks < ActiveRecord::Migration
  def change
    add_reference :tasks, :uncompletor, index: true
  end
end
