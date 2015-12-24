defmodule ChatDemo.ConversationTest do
  use ChatDemo.ModelCase
  use ChatDemo.ConnCase

  alias ChatDemo.Conversation

  user = Repo.get_by(ChatDemo.User, %{email: "testuser1@gmail.com"})
  @valid_attrs %{message: "some content", parent_id: 42, user_id: user.id}
  @invalid_attrs %{}

  setup do
    conn = conn()
    |> post session_path(conn, :create, %{"session": %{"email": "testuser1@gmail.com", "password": "foobar"}})
    {:ok, conn: conn}
  end 

  test "changeset with valid attributes" do
    changeset = Conversation.changeset(%Conversation{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Conversation.changeset(%Conversation{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "a reply to a conversation", context do
    conversation_params = %{message: "original message for a reply to a conversation"}
    post context[:conn], conversation_path(context[:conn], :create), conversation: conversation_params 
    conversation = Repo.get_by(Conversation, conversation_params) |> Repo.preload([:conversation_participants])
    ChatDemo.ConversationParticipant.create_from_params(["43","44"], conversation, Repo)
    conversation = Repo.get_by(Conversation, conversation_params) |> Repo.preload([:conversation_participants])
    {:ok, reply} = Conversation.reply(conversation.id, 43, "A reply") 

    assert reply.parent_id == conversation.id
    assert Enum.count(reply.conversation_participants) == Enum.count(conversation.conversation_participants)
  end
end
