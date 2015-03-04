class Assignment < ActiveRecord::Base
  belongs_to :task
  belongs_to :user
  belongs_to :assigner, class_name: 'User', foreign_key: 'assigner_id'
  
  validates :task, presence: true
  validates :user, presence: true
  validates :assigner, presence: true
end
