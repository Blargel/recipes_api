class RecipeStep < ApplicationRecord
  belongs_to :recipe

  validates :title, :order, presence: true
  validates :order, uniqueness: { scope: :recipe_id }
  validates :recipe, presence: true
end
