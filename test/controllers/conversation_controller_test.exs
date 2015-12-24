defmodule ChatDemo.ConversationControllerTest do
  use ChatDemo.ConnCase

  alias ChatDemo.Conversation

  user = Repo.get_by(ChatDemo.User, %{email: "testuser1@gmail.com"})
  @valid_attrs %{message: "some content", user_id: user.id}
  @invalid_attrs %{}

  setup do
    conn = conn()
    |> post session_path(conn, :create, %{"session": %{"email": "testuser1@gmail.com", "password": "foobar"}})
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, conversation_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing conversations"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, conversation_path(conn, :new)
    assert html_response(conn, 200) =~ "New conversation"
  end

  test "creates conversation with participants", %{conn: conn} do
    user2 = Repo.get_by(ChatDemo.User, %{email: "testuser2@gmail.com"})
    conversation_params = Map.merge @valid_attrs, %{ conversation_participants: ["#{user2.id}"] }
    conn = post conn, conversation_path(conn, :create), conversation: conversation_params 
    assert redirected_to(conn) == conversation_path(conn, :index)
    conversation = Repo.get_by(Conversation, @valid_attrs)
    assert conversation
    conversation_participants = Repo.all assoc(conversation, :conversation_participants)
    assert conversation_participants |> Enum.count > 0
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, conversation_path(conn, :create), conversation: @invalid_attrs
    assert html_response(conn, 302)
  end

  test "shows chosen resource", %{conn: conn} do
    user = Repo.get_by(ChatDemo.User, %{email: "testuser1@gmail.com"})
    conversation = Repo.insert! %Conversation{"user_id": user.id}
    conn = get conn, conversation_path(conn, :show, conversation)
    assert html_response(conn, 200) =~ "Show conversation"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, conversation_path(conn, :show, -1)
    end
  end

  test "deletes chosen resource", %{conn: conn} do
    conversation = Repo.insert! %Conversation{}
    conn = delete conn, conversation_path(conn, :delete, conversation)
    assert redirected_to(conn) == conversation_path(conn, :index)
    refute Repo.get(Conversation, conversation.id)
  end
end
