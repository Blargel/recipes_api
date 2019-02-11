require 'test_helper'

class AuthenticationControllerTest < ActionDispatch::IntegrationTest
  setup do
    user = User.create({
      name: "Abner",
      password: "asdfjkl",
      password_confirmation: "asdfjkl"
    })
  end

  test "authenticate endpoint returns an auth token when valid credentials" do
    params = {
      name: "Abner",
      password: "asdfjkl"
    }
    post authenticate_path, params: params

    assert_response :success
    assert_includes parsed_response.keys, "auth_token"
  end

  test "authenticate endpoint returns error when no credentials" do
    post authenticate_path

    assert_response :unauthorized
    assert_includes parsed_response.keys, "error"
  end

  test "authenticate endpoint returns error when invalid credentials" do
    params = {
      name: "Abner",
      password: "alwkefjlksdfj"
    }
    post authenticate_path

    assert_response :unauthorized
    assert_includes parsed_response.keys, "error"
  end
end
