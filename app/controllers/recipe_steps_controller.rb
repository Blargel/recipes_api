class RecipeStepsController < ApplicationController
  has_parents :user, :recipe
  permit_params :title, :description, :order
end
