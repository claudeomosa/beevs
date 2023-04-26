defmodule Beevs.WorkSpaces.ProjectMember do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "project_members" do
    belongs_to :project, Beevs.WorkSpaces.Project
    belongs_to :user, Beevs.Accounts.User
  end

  @doc false
  def changeset(project_members, attrs) do
    project_members
    |> cast(attrs, [:project_id, :user_id])
    |> cast_assoc(:project)
    |> cast_assoc(:user)
    |> validate_required([:project_id, :user_id])
  end
end
