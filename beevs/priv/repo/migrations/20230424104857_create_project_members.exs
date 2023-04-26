defmodule Beevs.Repo.Migrations.CreateProjectMembers do
  use Ecto.Migration

  def change do
    create table(:project_members, primary_key: false) do
      add :project_id, references(:projects, on_delete: :nothing), null: false, primary_key: true
      add :user_id, references(:users, on_delete: :nothing), null: false, primary_key: true
    end

    create unique_index(:project_members, [:project_id, :user_id],
             name: :project_members_project_id_user_id_unique_index
           )
  end
end
