require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:dave)
  end

  test "index endpoint returns success" do
    get users_path

    assert_response :success
    assert_kind_of Array, parsed_response
    assert_not_empty parsed_response
  end

  test "show endpoint returns success if user exists" do
    get user_path(@user.id)

    assert_response :success
    assert_kind_of Hash, parsed_response
    assert_equal @user.id, parsed_response["id"]
  end

  test "show endpoint returns error if user doesn't exist" do
    get user_path(0)

    assert_response :not_found
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "create endpoint returns success if validations pass" do
    params = {
      name: "Raymond",
      password: "very secure",
      password_confirmation: "very secure"
    }
    post users_path, params: params

    assert_response :success
    assert_kind_of Hash, parsed_response
    assert_equal "Raymond", parsed_response["name"]
  end

  test "create endpoint returns error if validations fail" do
    params = {
      name: "Raymond",
      password: "very secure",
      password_confirmation: "much secure"
    }
    post users_path, params: params

    assert_response :unprocessable_entity
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "update endpiont returns success if validations pass" do
    params = {
      name: "Sora",
      password: "uncrackable",
      password_confirmation: "uncrackable"
    }
    put user_path(@user.id), params: params

    assert_response :success
    assert_empty @response.body
  end

  test "update endpoint returns error if user does not exist" do
    params = {
      name: "Sora",
      password: "uncrackable",
      password_confirmation: "uncrackable"
    }
    put user_path(0), params: params

    assert_response :not_found
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "update endpoint returns error validations fail" do
    params = {
      name: "Sora",
      password: "uncrackable",
      password_confirmation: "wait what"
    }
    put user_path(@user.id), params: params

    assert_response :unprocessable_entity
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "delete endpoint returns success if user exists" do
    delete user_path(@user.id)

    assert_response :success
    assert_empty @response.body
  end

  test "delete endpoint returns error if user does not exist" do
    delete user_path(0)

    assert_response :not_found
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end
end
