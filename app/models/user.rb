class User < ApplicationRecord
  has_secure_password

  has_many :recipes, dependent: :destroy

  validates :name, :password, :password_confirmation, presence: true
  validates :name, uniqueness: true
  validates :password, confirmation: true

  # Remove the password_digest from responses
  def as_json options={}
    super(except: :password_digest)
  end
end
