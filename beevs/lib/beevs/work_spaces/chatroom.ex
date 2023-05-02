defmodule Beevs.WorkSpaces.Chatroom do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chatrooms" do
    belongs_to :project, Beevs.WorkSpaces.Project, foreign_key: :project_id
    has_many :messages, Beevs.WorkSpaces.Message

    timestamps()
  end

  @doc false
  def changeset(chatroom, attrs) do
    chatroom
    |> cast(attrs, [:project_id])
    |> cast_assoc(:project)
    |> validate_required([:project_id])
  end
end
