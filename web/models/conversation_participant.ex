defmodule ChatDemo.ConversationParticipant do
  use ChatDemo.Web, :model

  schema "conversation_participants" do
    field :state, :string
    belongs_to :conversation, ChatDemo.Conversation
    belongs_to :user, ChatDemo.User

    timestamps
  end

  @required_fields ~w(user_id conversation_id)
  @optional_fields ~w(state)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def create_from_params(nil, _conversation, _repo) do

  end

  def create_from_params(participants, conversation, repo) when is_list(participants) do
    for cp <- participants do
      { user_id, _ } = Integer.parse(cp)
      conversation_participant = Ecto.build_assoc(conversation, :conversation_participants, user_id: user_id)
      repo.insert(conversation_participant)
    end
  end
end
