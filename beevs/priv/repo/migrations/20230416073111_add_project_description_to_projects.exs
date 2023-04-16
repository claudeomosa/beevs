defmodule Beevs.Repo.Migrations.AddProjectDescriptionToProjects do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :project_description, :string, null: false
    end

  end
end
