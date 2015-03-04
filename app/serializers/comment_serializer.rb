class CommentSerializer < ActiveModel::Serializer
  attributes :id, :commentable_type, :commentable_id, :body
end
