class TokenSerializer < ActiveModel::Serializer
  attributes :id, :string, :expires_at
  
  has_one :user
end
