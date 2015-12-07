defmodule ChatDemo.Conversation do
  use ChatDemo.Web, :model

  schema "conversations" do
    field :message, :string
    field :user_id, :integer
    field :parent_id, :integer

    timestamps
  end

  @required_fields ~w(message user_id parent_id)
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
