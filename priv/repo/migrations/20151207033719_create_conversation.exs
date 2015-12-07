defmodule ChatDemo.Repo.Migrations.CreateConversation do
  use Ecto.Migration

  def change do
    create table(:conversations) do
      add :message, :string
      add :user_id, :integer
      add :parent_id, :integer

      timestamps
    end

  end
end
