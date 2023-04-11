defmodule Beevs.WorkSpaces.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :project_name, :string

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:project_name])
    |> validate_required([:project_name])
  end
end
