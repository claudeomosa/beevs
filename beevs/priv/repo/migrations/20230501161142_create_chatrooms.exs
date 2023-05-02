defmodule Beevs.Repo.Migrations.CreateChatrooms do
  use Ecto.Migration

  def change do
    create table(:chatrooms) do
      add :project_id, references(:projects, on_delete: :delete_all, null: false)

      timestamps()
    end

    create index(:chatrooms, [:project_id])
  end
end
