require 'test_helper'

class RecipeStepsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @step = recipe_steps(:one)
    @recipe = @step.recipe
    @user = @recipe.user
  end

  test "index endpoint returns success" do
    get user_recipe_recipe_steps_path(@user.id, @recipe.id)

    assert_response :success
    assert_kind_of Array, parsed_response
    assert_not_empty parsed_response
  end

  test "show endpoint returns success if step exists" do
    get user_recipe_recipe_step_path(@user.id, @recipe.id, @step.id)

    assert_response :success
    assert_kind_of Hash, parsed_response
    assert_equal @step.id, parsed_response["id"]
    assert_equal @recipe.id, parsed_response["recipe_id"]
  end

  test "show endpoint returns error if step doesn't exist" do
    get user_recipe_recipe_step_path(@user.id, @recipe.id, 0)

    assert_response :not_found
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "show endpoint returns error if recipe doesn't exist" do
    get user_recipe_recipe_step_path(@user.id, 0, @step.id)

    assert_response :not_found
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "show endpoint returns error if user doesn't exist" do
    get user_recipe_recipe_step_path(0, @recipe.id, @step.id)

    assert_response :not_found
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "show endpoint returns error if step does not belong to recipe" do
    other_step = recipe_steps(:two)
    get user_recipe_recipe_step_path(@user.id, @recipe.id, other_step.id)

    assert_response :not_found
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "create endpoint returns success if validations pass" do
    params = {
      title: "Sear with a flamethrower",
      description: "I swear I know how to cook",
      order: 1
    }
    post user_recipe_recipe_steps_path(@user.id, @recipe.id), params: params

    assert_response :success
    assert_kind_of Hash, parsed_response
    assert_equal "Sear with a flamethrower", parsed_response["title"]
  end

  test "create endpoint returns error if validations fail" do
    params = {
      title: "Sear with a flamethrower",
      description: "I swear I know how to cook"
    }
    post user_recipe_recipe_steps_path(@user.id, @recipe.id), params: params

    assert_response :unprocessable_entity
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "update endpiont returns success if validations pass" do
    params = {
      title: "Mash with a mallet",
      description: "Make sure the grains are uniform because that's totally possible.",
      order: 2
    }
    put user_recipe_recipe_step_path(@user.id, @recipe.id, @step.id), params: params

    assert_response :success
    assert_empty @response.body
  end

  test "update endpoint returns error if step does not exist" do
    params = {
      title: "Mash with a mallet",
      description: "Make sure the grains are uniform because that's totally possible.",
      order: 2
    }
    put user_recipe_recipe_step_path(@user.id, @recipe.id, 0), params: params

    assert_response :not_found
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "update endpoint returns error if validations fail" do
    params = {
      title: "",
      description: "Make sure the grains are uniform because that's totally possible.",
      order: 2
    }
    put user_recipe_recipe_step_path(@user.id, @recipe.id, @step.id), params: params

    assert_response :unprocessable_entity
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "delete endpoint returns success if step exists" do
    delete user_recipe_recipe_step_path(@user.id, @recipe.id, @step.id)

    assert_response :success
    assert_empty @response.body
  end

  test "delete endpoint returns error if step does not exist" do
    delete user_recipe_recipe_step_path(@user.id, @recipe.id, 0)

    assert_response :not_found
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end
end
