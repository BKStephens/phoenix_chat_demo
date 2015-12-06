defmodule ChatDemo.RoomChannelTest do
  @endpoint ChatDemo.Endpoint
  use ExUnit.Case, async: false
  use Plug.Test
  use Phoenix.ChannelTest
  alias ChatDemo.RoomChannel

  setup_all do
    @endpoint.start_link()
    :ok
  end

  test "join/3 with success" do
    {:ok, _client, socket} = subscribe_and_join(socket, RoomChannel, "rooms:lobby")
    assert socket.channel == ChatDemo.RoomChannel
    assert socket.topic == "rooms:lobby"
  end

  test "when a new message is received it should be broadcasted to subscribers" do
    {:ok, _client, socket} = subscribe_and_join(socket, RoomChannel, "rooms:lobby")
    push socket, "new:message", %{"user" => "Ben Stephens", "body" => "hello!"}
    assert_broadcast "new:message", %{user: "Ben Stephens", body: "hello!"}
  end
end
