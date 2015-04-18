class AlterPlanUploadLimit < ActiveRecord::Migration
  def change
    change_column :plans, :upload_limit, :integer, limit: 8
  end
end
