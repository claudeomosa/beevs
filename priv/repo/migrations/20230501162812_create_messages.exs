defmodule Beevs.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :text
      add :chatroom_id, references(:chatrooms, on_delete: :delete_all, null: false)
      add :user_id, references(:users, on_delete: :delete_all, null: false)

      timestamps()
    end

    create index(:messages, [:chatroom_id])
    create index(:messages, [:user_id])
  end
end
