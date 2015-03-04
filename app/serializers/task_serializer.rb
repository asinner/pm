class TaskSerializer < ActiveModel::Serializer
  attributes :id, :taskable_id, :taskable_type, :description
end
