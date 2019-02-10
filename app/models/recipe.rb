class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipe_steps, dependent: :destroy

  validates :title, presence: true
end
