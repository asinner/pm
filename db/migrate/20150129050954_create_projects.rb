class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.references :company, index: true
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
