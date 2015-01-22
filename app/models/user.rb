class User < ActiveRecord::Base
  attr_accessor 
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 5 }, if: :validate_password?
  
  has_secure_password
  
  has_many :tokens
  belongs_to :company
  
  def validate_password?
    password.present? || password_confirmation.present? || new_record?
  end
  
end
