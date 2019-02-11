require 'test_helper'

class RecipesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recipe = recipes(:one)
    @user = @recipe.user

    token = JsonWebToken.encode(user_id: @user.id)
    @auth_header = {
      authorization: token
    }
  end

  test "index endpoint returns success" do
    get user_recipes_path(@user.id), headers: @auth_header

    assert_response :success
    assert_kind_of Hash, parsed_response
    assert_not_empty parsed_response["recipes"]
  end

  test "show endpoint returns success if recipe exists" do
    get user_recipe_path(@user.id, @recipe.id), headers: @auth_header

    assert_response :success
    assert_kind_of Hash, parsed_response
    assert_equal @recipe.id, parsed_response["id"]
    assert_equal @user.id, parsed_response["user_id"]
  end

  test "show endpoint returns error if recipe doesn't exist but user does" do
    get user_recipe_path(@user.id, 0), headers: @auth_header

    assert_response :not_found
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "show endpoint returns error if user doesn't exist but recipe does" do
    get user_recipe_path(0, @recipe.id), headers: @auth_header

    assert_response :not_found
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "show endpoint returns error if recipe does not belong to user" do
    other_user = users(:jerry)
    get user_recipe_path(other_user, @recipe.id), headers: @auth_header

    assert_response :not_found
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "create endpoint returns success if validations pass" do
    params = {
      title: "Pizza",
      description: "It's literally just a pizza."
    }
    post user_recipes_path(@user.id), params: params, headers: @auth_header

    assert_response :success
    assert_kind_of Hash, parsed_response
    assert_equal "Pizza", parsed_response["title"]
  end

  test "create endpoint returns error if validations fail" do
    params = {
      title: "",
      description: "Gasp! A mysterious recipe!"
    }
    post user_recipes_path(@user.id), params: params, headers: @auth_header

    assert_response :unprocessable_entity
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "update endpiont returns success if validations pass" do
    params = {
      title: "Oxtail soup",
      description: "This is actually my favorite soup, by the way."
    }
    put user_recipe_path(@user.id, @recipe.id), params: params, headers: @auth_header

    assert_response :success
    assert_empty @response.body
  end

  test "update endpoint returns error if recipe does not exist" do
    params = {
      title: "Oxtail soup",
      description: "This is actually my favorite soup, by the way."
    }
    put user_recipe_path(@user.id, 0), params: params, headers: @auth_header

    assert_response :not_found
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "update endpoint returns error validations fail" do
    params = {
      title: "",
      description: "Wow! More mysterious recipes!"
    }
    put user_recipe_path(@user.id, @recipe.id), params: params, headers: @auth_header

    assert_response :unprocessable_entity
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "delete endpoint returns success if recipe exists" do
    delete user_recipe_path(@user.id, @recipe.id), headers: @auth_header

    assert_response :success
    assert_empty @response.body
  end

  test "delete endpoint returns error if recipe does not exist" do
    delete user_recipe_path(@user.id, 0), headers: @auth_header

    assert_response :not_found
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end
end
