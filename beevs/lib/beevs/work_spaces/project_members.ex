defmodule Beevs.WorkSpaces.ProjectMembers do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "project_members" do
    belongs_to :project, Beevs.WorkSpaces.Project
    belongs_to :member, Beevs.Accounts.User
  end

  @doc false
  def changeset(project_members, attrs) do
    project_members
    |> cast(attrs, [:project_id, :member_id])
    |> cast_assoc(:project)
    |> cast_assoc(:member)
    |> validate_required([:project_id, :member_id])
  end
end
