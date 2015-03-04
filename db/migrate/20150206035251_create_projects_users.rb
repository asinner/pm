class CreateProjectsUsers < ActiveRecord::Migration
  def change
    create_table :projects_users do |t|
      t.references :user, index: true
      t.references :project, index: true

      t.timestamps
    end
  end
end
