defmodule Beevs.WorkSpaces.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :project_name, :string
    belongs_to :user, Beevs.Accounts.User
    field :project_description, :string

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:project_name, :user_id, :project_description])
    |> cast_assoc(:user)
    |> validate_length(:project_name, min: 2, max: 20)
    |> validate_length(:project_description, min: 2, max: 210)
    |> validate_required([:project_name, :user_id, :project_description])
  end
end
