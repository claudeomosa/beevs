defmodule Beevs.WorkSpaces.Task do
  @moduledoc """
  Task schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    belongs_to :user, Beevs.Accounts.User
    field :status, :string
    field :task, :string
    field :priority, :integer, default: 0
    field :due_date, :string
    field :start_date, :string
    belongs_to :project, Beevs.WorkSpaces.Project

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:task, :user_id, :status, :project_id, :priority, :due_date, :start_date])
    |> cast_assoc(:project)
    |> cast_assoc(:user)
    |> validate_required([:task, :user_id, :status, :project_id])
  end
end
