class TaskSerializer < ActiveModel::Serializer
  attributes :id, :taskable_id, :taskable_type, :description, :completed, :completed_at, :uncompletor_id, :uncompleted_at

  has_one :completor
  has_one :uncompletor
end
