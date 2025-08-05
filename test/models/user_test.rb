require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(email: "test@example.com", password: "password", password_confirmation: "password")
  end

  test "valid user" do
    assert @user.valid?
  end

  test "email presence" do
    @user.email = ""
    assert_not @user.valid?
    assert_includes @user.errors[:email], "can't be blank"
  end

  test "email uniqueness" do
    @user.save!
    dup = User.new(email: "test@example.com", password: "secret123", password_confirmation: "secret123")
    assert_not dup.valid?
    assert_includes dup.errors[:email], "has already been taken"
  end

  test "authenticate with wrong password fails" do
    @user.save!
    assert_not @user.authenticate("wrongpass")
  end
end
