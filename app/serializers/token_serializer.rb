class TokenSerializer < ActiveModel::Serializer
  attributes :string, :expires_at
  
  has_one :user
end
