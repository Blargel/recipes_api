require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:dave)

    token = JsonWebToken.encode(user_id: @user.id)
    @auth_header = {
      authorization: token
    }
  end

  test "index endpoint paginates by default" do
    get users_path, headers: @auth_header

    assert_response :success
    assert_equal 25, parsed_response["users"].count
    assert_equal 31, parsed_response["count"]
  end

  test "index endpoint can change pages" do
    params = { page: 1 }
    get users_path, params: params, headers: @auth_header

    assert_response :success
    assert_equal 25, parsed_response["users"].count
    assert_equal 31, parsed_response["count"]
    page1_ids = parsed_response["users"].map{ |u| u["id"] }

    params = { page: 2}
    get users_path, params: params, headers: @auth_header

    assert_response :success
    assert_equal 6, parsed_response["users"].count
    assert_equal 31, parsed_response["count"]
    page2_ids = parsed_response["users"].map{ |u| u["id"] }

    assert_equal 0, (page1_ids & page2_ids).count
  end

  test "show endpoint returns success if user exists" do
    get user_path(@user.id), headers: @auth_header

    assert_response :success
    assert_kind_of Hash, parsed_response
    assert_equal @user.id, parsed_response["id"]
  end

  test "show endpoint returns error if user doesn't exist" do
    get user_path(0), headers: @auth_header

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
    put user_path(@user.id), params: params, headers: @auth_header

    assert_response :success
    assert_empty @response.body
  end

  test "update endpoint returns error if user does not exist" do
    params = {
      name: "Sora",
      password: "uncrackable",
      password_confirmation: "uncrackable"
    }
    put user_path(0), params: params, headers: @auth_header

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
    put user_path(@user.id), params: params, headers: @auth_header

    assert_response :unprocessable_entity
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "delete endpoint returns success if user exists" do
    delete user_path(@user.id), headers: @auth_header

    assert_response :success
    assert_empty @response.body
  end

  test "delete endpoint returns error if user does not exist" do
    delete user_path(0), headers: @auth_header

    assert_response :not_found
    assert_kind_of Hash, parsed_response
    assert_includes parsed_response.keys, "error"
  end

  test "index endpoint returns error if auth headers missing" do
    get users_path

    assert_response :unauthorized
    assert_includes parsed_response.keys, "error"
  end

  test "index endpoint returns error if auth headers invalid" do
    invalid_auth_header = {
      authorization: "faketoken"
    }
    get users_path, headers: invalid_auth_header

    assert_response :unauthorized
    assert_includes parsed_response.keys, "error"
  end
end
