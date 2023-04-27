defmodule Beevs.Repo.Migrations.AddUserIdToProjects do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end
end
