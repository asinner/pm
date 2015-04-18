class Comment < ActiveRecord::Base
  has_many :comments, as: :commentable
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  
  validates :commentable, presence: true
  validates :body, presence: true
  
  def project
    commentable = self.commentable
    until commentable.class == Discussion
      commentable = commentable.commentable
    end
    commentable.project
  end

  def discussion
    commentable = self.commentable
    until commentable.class == Discussion
      commentable = commentable.commentable
    end
    commentable
  end
end
