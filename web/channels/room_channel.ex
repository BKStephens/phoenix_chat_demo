defmodule ChatDemo.RoomChannel do
  use Phoenix.Channel

  def join("rooms:lobby", message, socket) do
    {:ok, socket}
  end

  def handle_in("new:message", message, socket) do
    broadcast! socket, "new:message", %{user: message["user"], body: message["body"]}
    {:noreply, socket}
  end
end
