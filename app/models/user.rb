class User < ActiveRecord::Base  
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 5 }, if: :validate_password?
  
  has_secure_password
  
  has_many :companies_users
  has_many :companies, through: :companies_users  
  has_many :tokens
  
  has_many :projects_users
  has_many :projects, through: :projects_users
  
  has_many :assignments
  has_many :tasks, through: :assignments
  
  def validate_password?
    password.present? || password_confirmation.present? || new_record?
  end
end
