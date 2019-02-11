require 'test_helper'

class RecipeStepTest < ActiveSupport::TestCase
  test "should not save step with no data" do
    step = RecipeStep.new

    assert_not step.save, "Saved the step with no data"
  end

  test "should not save recipe with no recipe_id" do
    step = RecipeStep.new
    step.title = "Mix the thingymabobs"
    step.order = 1

    assert_not step.save, "Saved the step with no recipe_id"
  end

  test "should not save recipe with no title" do
    recipe = Recipe.first
    step = RecipeStep.new
    step.order = 1
    step.recipe_id = recipe.id

    assert_not step.save, "Saved the step with no title"
  end

  test "should not save recipe with no order" do
    recipe = Recipe.first
    step = RecipeStep.new
    step.title = "Mix the thingymabobs"
    step.recipe_id = recipe.id

    assert_not step.save, "Saved the step with no order"
  end

  test "should not save recipe with order number already in use" do
    recipe = Recipe.first
    step = RecipeStep.new
    step.title = "Mix the thingymabobs"
    step.order = 99 # This number is in use for all recipes in fixtures
    step.recipe_id = recipe.id

    assert_not step.save, "Saved the step with invalid order"
  end

  test "should save recipe with valid data" do
    recipe = Recipe.first
    step = RecipeStep.new
    step.title = "Mix the thingymabobs"
    step.order = 1
    step.recipe_id = recipe.id

    assert step.save, "Failed to save the step with valid data"
  end
end
