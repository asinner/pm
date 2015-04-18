class Company < ActiveRecord::Base
  validates :name, presence: true
  
  has_many :companies_users
  has_many :users, through: :companies_users  
  has_one :subscription
  has_one :plan, through: :subscription
  has_many :invitations
  has_many :projects
  has_many :uploads  
  
  def active?
    self.subscription_status == 'active'
  end
  
  def inactive?
    !self.active?
  end
  
  def can_store?(upload)
    self.plan.upload_limit >= self.uploads.sum(:size) + (upload.size || 0)
  end
end
