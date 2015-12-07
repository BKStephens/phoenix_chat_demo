defmodule ChatDemo.ConversationTest do
  use ChatDemo.ModelCase

  alias ChatDemo.Conversation

  @valid_attrs %{message: "some content", parent_id: 42, user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Conversation.changeset(%Conversation{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Conversation.changeset(%Conversation{}, @invalid_attrs)
    refute changeset.valid?
  end
end
