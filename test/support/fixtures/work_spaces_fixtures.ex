defmodule Beevs.WorkSpacesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Beevs.WorkSpaces` context.
  """

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{
        project_name: "some project_name"
      })
      |> Beevs.WorkSpaces.create_project()

    project
  end

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        assignee: "some assignee",
        status: "some status",
        task: "some task"
      })
      |> Beevs.WorkSpaces.create_task()

    task
  end

  @doc """
  Generate a project_file.
  """
  def project_file_fixture(attrs \\ %{}) do
    {:ok, project_file} =
      attrs
      |> Enum.into(%{
        description: "some description"
      })
      |> Beevs.WorkSpaces.create_project_file()

    project_file
  end

  @doc """
  Generate a deleted_project.
  """
  def deleted_project_fixture(attrs \\ %{}) do
    {:ok, deleted_project} =
      attrs
      |> Enum.into(%{

      })
      |> Beevs.WorkSpaces.create_deleted_project()

    deleted_project
  end

  @doc """
  Generate a deleted_task.
  """
  def deleted_task_fixture(attrs \\ %{}) do
    {:ok, deleted_task} =
      attrs
      |> Enum.into(%{

      })
      |> Beevs.WorkSpaces.create_deleted_task()

    deleted_task
  end
end
