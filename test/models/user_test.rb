require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "should not save user with no data" do
    user = User.new

    assert_not user.save, "Saved the user with no data"
  end

  test "should not save user with name but no password" do
    user = User.new
    user.name = "Bob"

    assert_not user.save, "Saved the user with no password"
  end

  test "should not save user with mismatched password confirmation" do
    user = User.new
    user.name = "Bob"
    user.password = "very secure"
    user.password_confirmation = "super secure"

    assert_not user.save, "Saved the user with mismatched password confirmation"
  end

  test "should not save user with same name as existing user" do
    user = User.new
    user.name = "Dave" # this name is already taken in the fixtures
    user.password = user.password_confirmation = "very secure"

    assert_not user.save, "Saved the user with a name that was already taken"
  end

  test "should save user with name and matching password confirmation" do
    user = User.new
    user.name = "Bob"
    user.password = user.password_confirmation = "very secure"

    assert user.save, "Failed to save user with valid fields"
  end

  test "should not display user's password_digest in json responses" do
    user = User.first
    assert_not_includes user.as_json.keys, :password_digest
  end
end
