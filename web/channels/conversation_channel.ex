defmodule ChatDemo.ConversationChannel do
  use Phoenix.Channel

  def join("conversations:" <> _conversation_id, message, socket) do
    {:ok, socket}
  end

  def handle_in("new:message", message, socket) do
    IO.puts socket.assigns[:current_user]
    current_user = ChatDemo.Repo.get_by(ChatDemo.User, %{id: socket.assigns[:current_user]})
    broadcast! socket, "new:message", %{user: current_user.email, body: message["body"]}
    {:noreply, socket}
  end
end
