class Upload < ActiveRecord::Base
  validates :title, presence: true
  validates :user, presence: true
  validates :size, presence: true, numericality: {less_than_or_equal_to: 50.megabytes}
  validates :attachable, presence: true
  validates :url, presence: true
  validates :mime_type, presence: true
  validates :key, presence: true
  
  belongs_to :attachable, polymorphic: true
  belongs_to :user
  belongs_to :company
  
  def project
    return self.attachable if self.attachable.class == Project
    self.attachable.project
  end
  
  def generate_key
    key = loop do
      random_key = SecureRandom::hex(10)
      break random_key unless Upload.exists?(key: random_key)
    end
    self.key = key
  end
end
