class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :taskable, polymorphic: true, index: true
      t.string :description
      t.references :creator, index: true

      t.timestamps
    end
  end
end
