defmodule ChatDemo.UserTest do
  use ChatDemo.ModelCase

  alias ChatDemo.User

  @valid_attrs %{password: "some content", email: "test_user@gmail.com"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
