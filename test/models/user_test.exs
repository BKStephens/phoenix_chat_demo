defmodule ChatDemo.UserTest do
  use ChatDemo.ModelCase
  use ChatDemo.ConnCase

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

  test "get all users besides the current user", context do
    conn = conn()
    #TODO: refactor to use https://github.com/sinetris/factory_girl_elixir
    user1_params = %{email: "user1@gmail.com", password: "foobar"}
    user2_params = %{email: "user2@gmail.com", password: "foobar"}
    post conn, registration_path(conn, :create), "user": user1_params
    post conn, registration_path(conn, :create), "user": user2_params
    user1 = Repo.get_by(User, Map.take(user1_params, [:email]))
    user2 = Repo.get_by(User, Map.take(user2_params, [:email]))

    all_other_users = User.all_other_users(Repo, user1.id)
    assert Enum.count(all_other_users) == 1
  end
end
