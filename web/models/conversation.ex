defmodule ChatDemo.Conversation do
  use ChatDemo.Web, :model

  alias ChatDemo.Repo
  alias ChatDemo.Conversation
  alias ChatDemo.ConversationParticipant

  schema "conversations" do
    field :message, :string
    field :user_id, :integer
    field :parent_id, :integer

    has_many :conversation_participants, ChatDemo.ConversationParticipant
    timestamps
  end

  @required_fields ~w(message user_id)
  @optional_fields ~w(parent_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_assoc(:conversation_participants, required: true)
  end

  def reply(conversation_id, user_id, message) do
    reply_params = %{ message: message,
                      user_id: user_id,
                      parent_id: conversation_id }
    changeset = Conversation.changeset(%Conversation{}
                |> Repo.preload([:conversation_participants]),
                reply_params)
    {:ok, reply} = Repo.insert(changeset)

    conversation_participants = Repo.all(from cp in ConversationParticipant,
                                         where: cp.conversation_id == ^conversation_id,
                                         select: cp) 
                                |> Enum.map(&(Integer.to_string(&1.user_id)))
    ConversationParticipant.create_from_params(conversation_participants, reply, Repo)

    {:ok, Repo.get(Conversation, reply.id) |> Repo.preload([:conversation_participants])}
  end
end
