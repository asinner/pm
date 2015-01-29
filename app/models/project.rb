class Project < ActiveRecord::Base
  belongs_to :company
  
  validates :name, presence: true
  validates :company, presence: true
end
