defmodule Beevs.Repo.Migrations.CreateProjectMembers do
  use Ecto.Migration

  def change do
    create table(:project_members, primary_key: false) do
      add :project_id, references(:projects, on_delete: :nothing), null: false, primary_key: true
      add :user_id, references(:users, on_delete: :nothing), null: false, primary_key: true
    end

    create index(:project_members, [:project_id])
    create index(:project_members, [:user_id])
  end
end
