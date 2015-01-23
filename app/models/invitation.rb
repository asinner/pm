class Invitation < ActiveRecord::Base
  validates :recipient, presence: true
  validates :key, presence: true
  validates :company, presence: true
  
  belongs_to :company
end
