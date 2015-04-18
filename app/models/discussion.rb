class Discussion < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  
  validates :project, presence: true
  validates :user, presence: true
  validates :title, presence: true
  
  has_many :comments, as: :commentable
  
  alias_method :author, :user

  def discussion
  	self
  end
end
