defmodule Beevs.WorkSpaces.Message do
  @moduledoc """
  Message schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :body, :string
    belongs_to :chatroom, Beevs.WorkSpaces.Chatroom, foreign_key: :chatroom_id
    belongs_to :user, Beevs.Accounts.User, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body, :chatroom_id, :user_id])
    |> cast_assoc(:chatroom)
    |> cast_assoc(:user)
    |> validate_required([:body, :chatroom_id, :user_id])
  end
end
