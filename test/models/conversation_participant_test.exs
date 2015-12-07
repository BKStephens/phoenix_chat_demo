defmodule ChatDemo.ConversationParticipantTest do
  use ChatDemo.ModelCase

  alias ChatDemo.ConversationParticipant

  @valid_attrs %{conversation_id: 42, state: "some content", user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ConversationParticipant.changeset(%ConversationParticipant{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ConversationParticipant.changeset(%ConversationParticipant{}, @invalid_attrs)
    refute changeset.valid?
  end
end
