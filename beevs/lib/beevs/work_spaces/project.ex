defmodule Beevs.WorkSpaces.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :project_name, :string
    belongs_to :user, Beevs.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:project_name, :user_id])
    |> validate_required([:project_name, :user_id])
  end
end
