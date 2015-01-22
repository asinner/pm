class Company < ActiveRecord::Base
  validates :name, presence: true
  
  has_many :employees, class_name: 'User'
  has_many :invitations
end
