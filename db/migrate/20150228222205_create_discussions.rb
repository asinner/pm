class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.references :project, index: true
      t.references :creator, index: true
      t.string :title

      t.timestamps
    end
  end
end
