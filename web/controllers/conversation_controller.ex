defmodule ChatDemo.ConversationController do
  use ChatDemo.Web, :controller

  alias ChatDemo.Conversation

  plug :scrub_params, "conversation" when action in [:create, :update]

  def index(conn, _params) do
    conversations = Repo.all(Conversation)
    render(conn, "index.html", conversations: conversations)
  end

  def new(conn, _params) do
    changeset = Conversation.changeset(%Conversation{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"conversation" => conversation_params}) do
    changeset = Conversation.changeset(%Conversation{}, conversation_params)

    case Repo.insert(changeset) do
      {:ok, _conversation} ->
        conn
        |> put_flash(:info, "Conversation created successfully.")
        |> redirect(to: conversation_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    conversation = Repo.get!(Conversation, id)
    render(conn, "show.html", conversation: conversation)
  end

  def edit(conn, %{"id" => id}) do
    conversation = Repo.get!(Conversation, id)
    changeset = Conversation.changeset(conversation)
    render(conn, "edit.html", conversation: conversation, changeset: changeset)
  end

  def update(conn, %{"id" => id, "conversation" => conversation_params}) do
    conversation = Repo.get!(Conversation, id)
    changeset = Conversation.changeset(conversation, conversation_params)

    case Repo.update(changeset) do
      {:ok, conversation} ->
        conn
        |> put_flash(:info, "Conversation updated successfully.")
        |> redirect(to: conversation_path(conn, :show, conversation))
      {:error, changeset} ->
        render(conn, "edit.html", conversation: conversation, changeset: changeset)
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
