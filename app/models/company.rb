class Company < ActiveRecord::Base
  validates :name, presence: true
  
  has_many :companies_users
  has_many :users, through: :companies_users
  
  has_many :invitations
  has_many :projects
  
  def active?
    self.subscription_status == 'active'
  end
end
