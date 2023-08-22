defmodule Beevs.Repo.Migrations.AddTaskPriorityAndDatesFieldsToTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :priority, :integer, default: 0
      add :start_date, :string
      add :due_date, :string
    end
  end
end
