class AddCompanyReferenceToUploads < ActiveRecord::Migration
  def change
    add_reference :uploads, :company, index: true
  end
end
