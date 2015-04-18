class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :company_id
end
