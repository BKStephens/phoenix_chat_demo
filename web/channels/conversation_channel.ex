defmodule ChatDemo.ConversationChannel do
  use Phoenix.Channel

  def join("conversations:" <> _conversation_id, message, socket) do
    {:ok, socket}
  end

  def handle_in("new:message", message, socket) do
    user_id =  socket.assigns[:current_user]
    "conversations:" <> conversation_id = socket.topic

    current_user = ChatDemo.Repo.get_by(ChatDemo.User, %{id: user_id})
    broadcast! socket, "new:message", %{user: current_user.email, body: message["body"]}
    ChatDemo.Conversation.reply(conversation_id, user_id, message["body"])

    {:noreply, socket}
  end
end
