defmodule ChatDemo.ConversationParticipant do
  use ChatDemo.Web, :model

  schema "conversation_participants" do
    field :user_id, :integer
    field :state, :string
    belongs_to :conversation, ChatDemo.Conversation

    timestamps
  end

  @required_fields ~w(user_id conversation_id state)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
