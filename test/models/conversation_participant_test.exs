defmodule ChatDemo.ConversationParticipantTest do
  use ChatDemo.ModelCase
  use ChatDemo.ConnCase

  alias ChatDemo.Conversation
  alias ChatDemo.ConversationParticipant

  @valid_attrs %{conversation_id: 42, state: "some content", user_id: 42}
  @invalid_attrs %{}

  setup_all do
    conn = conn()
    #TODO: refactor to use https://github.com/sinetris/factory_girl_elixir
    conversation_params = %{message: "some content", user_id: 42}
    post conn, conversation_path(conn, :create), conversation: conversation_params 
    conversation = Repo.get_by(Conversation, conversation_params)
    {:ok, conn: conn, conversation: conversation}
  end

  test "changeset with valid attributes" do
    changeset = ConversationParticipant.changeset(%ConversationParticipant{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ConversationParticipant.changeset(%ConversationParticipant{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "create_from_params with participants", context do
    ConversationParticipant.create_from_params(["1"], context[:conversation], Repo)
  end

  test "create_from_params without participants", context do
    ConversationParticipant.create_from_params(nil, context[:conversation], Repo)
  end
end
