defmodule ChatDemo.ConversationController do
  use ChatDemo.Web, :controller

  alias ChatDemo.Conversation
  alias ChatDemo.ConversationParticipant
  alias ChatDemo.User

  plug :scrub_params, "conversation" when action in [:create, :update]

  def index(conn, _params) do
    user_id = get_session(conn, :current_user) || 0
    conversations = Repo.all(from c in Conversation,
                             join: cp in ConversationParticipant, 
                             on: c.id == cp.conversation_id,
                             where: is_nil(c.parent_id)
                                    and cp.user_id == ^user_id,
                             preload: [:user])
    render(conn, "index.html", conversations: conversations)
  end

  def new(conn, _params) do
    users = User.all_other_users(Repo, get_session(conn, :current_user))
    changeset = Conversation.changeset(%Conversation{} |> Repo.preload [:conversation_participants])
    render(conn, "new.html", users: users, changeset: changeset)
  end

  def create(conn, %{"conversation" => conversation_params}) do
    current_user = get_session(conn, :current_user)
    conversation = %{message: conversation_params["message"],
                     user_id: current_user}
    conversation_changeset = Conversation.changeset(%Conversation{}, conversation)

    case Repo.insert(conversation_changeset) do
      {:ok, conversation} ->
        #TODO: figure out how to insert nested attributes in one go instead of doing it manually
        if conversation_params["conversation_participants"] do
          participants = [Integer.to_string(current_user) | conversation_params["conversation_participants"]] 
        end
        ConversationParticipant.create_from_params(participants, conversation, Repo)
        conn
        |> put_flash(:info, "Conversation created successfully.")
        |> redirect(to: conversation_path(conn, :index))
      {:error, _changeset} ->
        redirect conn, to: "/conversations/new"
    end
  end

  def show(conn, %{"id" => id}) do
    conversation = Repo.get!(Conversation, id) |> Repo.preload [conversation_participants: [:user]]
    messages = Repo.all(from c in Conversation,
                       where: c.parent_id == ^id or c.id == ^id,
                       select: c) |> Repo.preload [:user]
    render(conn, "show.html", conversation: conversation, conversation_messages: messages)
  end

  def delete(conn, %{"id" => id}) do
    conversation = Repo.get!(Conversation, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(conversation)

    conn
    |> put_flash(:info, "Conversation deleted successfully.")
    |> redirect(to: conversation_path(conn, :index))
  end
end
