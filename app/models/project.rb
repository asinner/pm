class Project < ActiveRecord::Base
  has_many :projects_users
  has_many :users, through: :projects_users
  has_many :discussions
  has_many :tasks, as: :taskable
  has_many :uploads, as: :attachable
    
  belongs_to :company
  
  validates :name, presence: true
  validates :company, presence: true
  
  def team
    self.users
  end
end
