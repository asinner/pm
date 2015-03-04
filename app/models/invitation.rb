class Invitation < ActiveRecord::Base
  validates :recipient, presence: true
  validates :key, presence: true

  belongs_to :invitable, polymorphic: true
  belongs_to :sender, class_name: 'User', foreign_key: 'user_id'
end
