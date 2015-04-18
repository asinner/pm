class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.integer :size, limit: 8
      t.references :attachable, polymorphic: true, index: true
      t.string :title
      t.references :user, index: true
      t.string :url
      t.string :mime_type

      t.timestamps
    end
  end
end
