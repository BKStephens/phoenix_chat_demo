defmodule ChatDemo.ConversationController do
  use ChatDemo.Web, :controller

  alias ChatDemo.Conversation
  alias ChatDemo.ConversationParticipant
  alias ChatDemo.User

  plug :scrub_params, "conversation" when action in [:create, :update]

  def index(conn, _params) do
    conversations = Repo.all(Conversation)
    render(conn, "index.html", conversations: conversations)
  end

  def new(conn, _params) do
    #TODO: figure out how to use session data in tests
    users = User.all_other_users(Repo, 
                                 get_session(conn, :current_user) || 0)
    changeset = Conversation.changeset(%Conversation{} |> Repo.preload [:conversation_participants])
    render(conn, "new.html", users: users, changeset: changeset)
  end

  def create(conn, %{"conversation" => conversation_params}) do
    #TODO: figure out how to set session from tests and stop getting user_id from params
    current_user = conversation_params["user_id"] || get_session(conn, :current_user)
    conversation = %{message: conversation_params["message"],
                     user_id: current_user}
    conversation_changeset = Conversation.changeset(%Conversation{},conversation)

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
      {:error, changeset} ->
        redirect conn, to: "/conversations/new"
    end
  end

  def show(conn, %{"id" => id}) do
    conversation = Repo.get!(Conversation, id) |> Repo.preload [conversation_participants: [:user]]
    render(conn, "show.html", conversation: conversation)
  end

  def edit(conn, %{"id" => id}) do
    conversation = Repo.get!(Conversation, id) |> Repo.preload [:conversation_participants]
    #TODO: figure out how to use session data in tests
    users = User.all_other_users(Repo, 
                                 get_session(conn, :current_user) || 0)
    changeset = Conversation.changeset(conversation)
    render(conn, "edit.html", conversation: conversation, users: users, changeset: changeset)
  end

  def update(conn, %{"id" => id, "conversation" => conversation_params}) do
    conversation = Repo.get!(Conversation, id) |> Repo.preload [:conversation_participants]

    changeset = Conversation.changeset(conversation, conversation_params)
    case Repo.update(changeset) do
      {:ok, conversation} ->
        conn
        |> put_flash(:info, "Conversation updated successfully.")
        |> redirect(to: conversation_path(conn, :show, conversation))
      {:error, changeset} ->
        render(conn, 
              "edit.html", 
              conversation: conversation, 
              #TODO: figure out how to use session data in tests
              users: User.all_other_users(Repo, 
                                          get_session(conn, :current_user) || 0), 
              changeset: changeset)
    end
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
