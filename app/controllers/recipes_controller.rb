class RecipesController < ApplicationController
  has_parents :user
  permit_params :title, :description
end
