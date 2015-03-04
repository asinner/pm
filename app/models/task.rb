class Task < ActiveRecord::Base
  belongs_to :taskable, polymorphic: true
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  has_many :tasks, as: :taskable
  
  has_many :assignments
  has_many :users, through: :assignments
  
  validates :description, presence: true
  validates :taskable, presence: true
  
  def project
    taskable = self.taskable
    until taskable.class == Project
      taskable = taskable.taskable
    end
    taskable
  end
end
