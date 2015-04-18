class UploadSerializer < ActiveModel::Serializer
  attributes :id, :title, :size, :mime_type, :attachable_type, :attachable_id
end
