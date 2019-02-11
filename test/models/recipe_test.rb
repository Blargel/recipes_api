require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  test "should not save recipe with no data" do
    recipe = Recipe.new

    assert_not recipe.save, "Saved the recipe with no data"
  end

  test "should not save recipe with no user_id" do
    recipe = Recipe.new
    recipe.title = "Cheese Danish"

    assert_not recipe.save, "Saved the recipe with no user_id"
  end

  test "should not save recipe with a user_id for a user that doesn't exist" do
    recipe = Recipe.new
    recipe.title = "Cheese Danish"
    recipe.user_id = 0

    assert_not recipe.save, "Saved the recipe with invalid user_id"
  end

  test "should not save user with no title" do
    user = User.first
    recipe = Recipe.new
    recipe.user_id = user.id

    assert_not recipe.save, "Saved the recipe with no title"
  end

  test "should save the user with a title and valid user_id" do
    user = User.first
    recipe = Recipe.new
    recipe.user_id = user.id
    recipe.title = "Cheese Danish"
  end
end
