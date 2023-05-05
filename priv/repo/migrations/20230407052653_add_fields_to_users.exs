defmodule Beevs.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:first_name, :string)
      add(:last_name, :string)
      add(:username, :string, unique: true)
      add(:avatar, :string)
      add(:job, :string, default: "project_manager")
    end
  end
end
