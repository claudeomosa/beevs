defmodule Beevs.WorkSpaces.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :assignee, :string
    field :status, :string
    field :task, :string
    belongs_to :project, Beevs.WorkSpaces.Project

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:task, :assignee, :status])
    |> validate_required([:task, :assignee, :status])
  end
end
