defmodule ChatDemo.ConversationChannelTest do
  @endpoint ChatDemo.Endpoint
  use ExUnit.Case, async: false
  use Plug.Test
  use Phoenix.ChannelTest
  alias ChatDemo.ConversationChannel

  setup_all do
    @endpoint.start_link()
    :ok
  end

  test "join/3 with success" do
    {:ok, _client, socket} = subscribe_and_join(socket, ConversationChannel, "conversations:1")
    assert socket.channel == ChatDemo.ConversationChannel
    assert socket.topic == "conversations:1"
  end

  test "when a new message is received it should be broadcasted to subscribers" do
    {:ok, _client, socket} = subscribe_and_join(socket, ConversationChannel, "conversations:1")
    push socket, "new:message", %{"user" => "Ben Stephens", "body" => "hello!"}
    assert_broadcast "new:message", %{user: "Ben Stephens", body: "hello!"}
  end
end
