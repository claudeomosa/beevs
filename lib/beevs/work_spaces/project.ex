defmodule Beevs.WorkSpaces.Project do
  @moduledoc """
  Project schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field(:project_name, :string)
    belongs_to(:user, Beevs.Accounts.User)
    field(:project_description, :string)
    has_one(:chatroom, Beevs.WorkSpaces.Chatroom, on_delete: :delete_all)
    has_many(:tasks, Beevs.WorkSpaces.Task, on_delete: :delete_all)
    has_many(:project_files, Beevs.WorkSpaces.ProjectFile, on_delete: :delete_all)

    many_to_many(:members, Beevs.Accounts.User,
      join_through: Beevs.WorkSpaces.ProjectMember,
      on_replace: :delete,
      on_delete: :delete_all
    )

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

  def insert_member(project, user) do
    project
    |> cast(%{}, [:project_name, :user_id, :project_description])
    |> cast_assoc(:members, [user | project.members])
  end
end
