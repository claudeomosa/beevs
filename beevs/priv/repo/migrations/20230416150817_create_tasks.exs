defmodule Beevs.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :task, :string
      add :user_id, references(:users, on_delete: :delete_all)
      add :status, :string
      add :project_id, references(:projects, on_delete: :delete_all)

      timestamps()
    end

    create index(:tasks, [:project_id, :user_id])
  end
end
