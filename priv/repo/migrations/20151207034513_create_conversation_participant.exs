defmodule ChatDemo.Repo.Migrations.CreateConversationParticipant do
  use Ecto.Migration

  def change do
    create table(:conversation_participants) do
      add :user_id, :integer
      add :conversation_id, :integer
      add :state, :string

      timestamps
    end

  end
end
