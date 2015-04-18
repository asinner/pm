class Task < ActiveRecord::Base
  belongs_to :taskable, polymorphic: true
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  belongs_to :completor, class_name: 'User', foreign_key: 'completor_id'
  belongs_to :uncompletor, class_name: 'User', foreign_key: 'uncompletor_id'

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

  def complete(state, user)
    if state == true
      self.completed = true
      self.completor = user
      self.completed_at = Time.now
    elsif state == false
      self.completed = false
      self.uncompletor = user
      self.uncompleted_at = Time.now
    end
  end
end
