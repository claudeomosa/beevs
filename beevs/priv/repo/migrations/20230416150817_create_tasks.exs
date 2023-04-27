defmodule Beevs.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :task, :string
      add :assignee, :string
      add :status, :string
      add :project_id, references(:projects, on_delete: :delete_all)

      timestamps()
    end

    create index(:tasks, [:project_id])
  end
end
