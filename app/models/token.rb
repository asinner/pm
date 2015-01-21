class Token < ActiveRecord::Base
  belongs_to :user
  
  validates :string, presence: true, uniqueness: true
  validates :user, presence: true
  validates :expires_at, presence: true
end
