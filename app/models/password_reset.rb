class PasswordReset < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true
  validates :secret, presence: true
  validates :expires_at, presence: true
  
  def expired?
    self.expires_at < Time.current
  end
end
