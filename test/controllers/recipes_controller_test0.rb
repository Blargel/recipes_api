require 'test_helper'

class RecipesControllerTest < ActionDispatch::IntegrationTest
  test "index endpoint returns success" do
    user = User.first
    get user_recipes_path(user.id)

    assert_response :success
    assert_kind_of Array, parsed_response
    assert_not_empty parsed_response
  end

  test "show endpoint returns success if recipe exists" do
    user = User.first
    recipe = user.recipes.first
    get user_recipe_path(user.id, recipe.id)

    assert_response :success
    assert_kind_of Hash, parsed_response
    assert_equal recipe.id, parsed_response["id"]
    assert_equal user.id, parsed_response["user_id"]
  end

  test "show endpoint returns error if recipe doesn't exist but user does" do
    user = User.first
    get user_recipe_path(user.id, 0)

    assert_response :not_found
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "show endpoint returns error if user doesn't exist but recipe does" do
    recipe = Recipe.first
    get user_recipe_path(0, recipe.id)

    assert_response :not_found
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "show endpoint returns error if recipe does not belong to user" do
    user1 = User.first
    user2 = User.last
    recipe = user1.recipes.first
    get user_recipe_path(user2, recipe.id)

    assert_response :not_found
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "create endpoint returns success if validations pass" do
    user = User.first
    params = {
      title: "Pizza",
      description: "It's literally just a pizza."
    }
    post user_recipes_path(user.id), params: params

    assert_response :success
    assert_kind_of Hash, parsed_response
    assert_equal "Pizza", parsed_response["title"]
  end

  test "create endpoint returns error if validations fail" do
    user = User.first
    params = {
      title: "",
      description: "Gasp! A mysterious recipe!"
    }
    post user_recipes_path(user.id), params: params

    assert_response :unprocessable_entity
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "update endpiont returns success if validations pass" do
    user = User.first
    recipe = user.recipes.first
    params = {
      title: "Oxtail soup",
      description: "This is actually my favorite soup, by the way."
    }
    put user_recipe_path(user.id, recipe.id), params: params

    assert_response :success
    assert_empty @response.body
  end

  test "update endpoint returns error if recipe does not exist" do
    user = User.first
    params = {
      title: "Oxtail soup",
      description: "This is actually my favorite soup, by the way."
    }
    put user_recipe_path(user.id, 0), params: params

    assert_response :not_found
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "update endpoint returns error validations fail" do
    user = User.first
    recipe = user.recipes.first
    params = {
      title: "",
      description: "Wow! More mysterious recipes!"
    }
    put user_recipe_path(user.id, recipe.id), params: params

    assert_response :unprocessable_entity
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "delete endpoint returns success if recipe exists" do
    user = User.first
    recipe = user.recipes.first
    delete user_recipe_path(user.id, recipe.id)

    assert_response :success
    assert_empty @response.body
  end

  test "delete endpoint returns error if recipe does not exist" do
    user = User.first
    delete user_recipe_path(user.id, 0)

    assert_response :not_found
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end
end
