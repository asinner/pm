class AddUncompletedAtToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :uncompleted_at, :datetime
  end
end
