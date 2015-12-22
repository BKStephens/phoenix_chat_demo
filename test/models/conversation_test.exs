defmodule ChatDemo.ConversationTest do
  use ChatDemo.ModelCase
  use ChatDemo.ConnCase

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

  test "a reply to a conversation" do
    conversation_params = %{message: "some content", user_id: 42}
    post conn, conversation_path(conn, :create), conversation: conversation_params 
    conversation = Repo.get_by(Conversation, conversation_params) |> Repo.preload([:conversation_participants])
    ChatDemo.ConversationParticipant.create_from_params(["43","44"], conversation, Repo)
    conversation = Repo.get_by(Conversation, conversation_params) |> Repo.preload([:conversation_participants])
    {:ok, reply} = Conversation.reply(conversation.id, 43, "A reply") 

    assert reply.parent_id == conversation.id
    assert Enum.count(reply.conversation_participants) == Enum.count(conversation.conversation_participants)
  end
end
