defmodule ChatDemo.ConversationChannelTest do
  @endpoint ChatDemo.Endpoint
  use ExUnit.Case, async: false
  use Plug.Test
  use Phoenix.ChannelTest
  use ChatDemo.ConnCase

  alias ChatDemo.ConversationChannel

  setup_all do
    @endpoint.start_link()
    conn = conn()
    |> post session_path(conn, :create, %{"session": %{"email": "testuser1@gmail.com", "password": "foobar"}})
    {:ok, conn: conn}
  end

  test "join/3 with success" do
    {:ok, _client, socket} = subscribe_and_join(socket, ConversationChannel, "conversations:1")
    assert socket.channel == ChatDemo.ConversationChannel
    assert socket.topic == "conversations:1"
  end

  test "when a new message is received it should be broadcast to subscribers", context do
    user = Repo.get_by(ChatDemo.User, %{email: "testuser1@gmail.com"})
    {:ok, _client, socket} = socket("user:id", %{current_user: 1}) 
                             |> subscribe_and_join(ConversationChannel, "conversations:1")

    push socket, "new:message", %{"user" => "testuser1@gmail.com", "body" => "hello!"}
    assert_broadcast "new:message", %{user: "testuser1@gmail.com", body: "hello!"}
  end

  test "when a typing_indicator is received it should be broadcast to subsribers" do
    user = Repo.get_by(ChatDemo.User, %{email: "testuser1@gmail.com"})
    {:ok, _client, socket} = socket("user:id", %{current_user: 1}) 
                             |> subscribe_and_join(ConversationChannel, "conversations:1")
    push socket, "typing_indicator", %{"user" => "testuser1@gmail.com"}
    assert_broadcast "typing_indicator", %{user: %{email: "testuser1@gmail.com", id: 1}}
  end
end
