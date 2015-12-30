defmodule ChatDemo.ConversationChannel do
  use Phoenix.Channel

  def join("conversations:" <> _conversation_id, message, socket) do
    {:ok, socket}
  end

  def handle_in("new:message", message, socket) do
    "conversations:" <> conversation_id = socket.topic
    current_user = get_current_user(socket)
    broadcast! socket, "new:message", %{user: current_user.email, body: message["body"]}
    ChatDemo.Conversation.reply(conversation_id, current_user.id, message["body"])

    {:noreply, socket}
  end

  def handle_in("typing_indicator", _message, socket) do
    current_user = get_current_user(socket)
    broadcast! socket, "typing_indicator", %{user: %{id: current_user.id,
                                                     email: current_user.email}}

    {:noreply, socket}
  end

  defp get_current_user(socket) do
    user_id = socket.assigns[:current_user]
    ChatDemo.Repo.get_by(ChatDemo.User, %{id: user_id})
  end
end
