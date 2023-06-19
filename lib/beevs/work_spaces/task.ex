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
    |> compare_dates()
  end

  defp compare_dates(changeset) do
    start_date = get_field(changeset, :start_date)
    due_date = get_field(changeset, :due_date)
    if start_date == nil || due_date == nil do
      changeset
    else
    if start_date > due_date do
      add_error(changeset, :start_date, "Start date cannot be greater than due date")
    else
      changeset
    end
  end
  end
end
