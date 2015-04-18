class Api::V1::UploadsController < ApplicationController
  before_action :authenticate_user
  
  def create
    attachable = find_attachable(params)

    upload = Upload.new(
      attachable: attachable,
      size: params[:size],
      mime_type: params[:mime_type],
      title: params[:title],
      user_id: current_user.id
    )
    
    upload.company = upload.project.company
    
    authorize upload
    
    return render status: 402, json: 'Company must renew subscription' unless upload.company.active?
    return render status: 402, json: 'Company must upgrade subscription. There is not enough space on the current plan to upload this file.' unless upload.company.can_store?(upload)
    
    upload.generate_key
    upload.url = S3_BUCKET.objects["upload/#{upload.key}"]
    
    if upload.save
      render status: 201, json: upload
    else
      render status: 422, json: upload.errors
    end
  end
end
