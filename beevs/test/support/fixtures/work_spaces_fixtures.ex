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
end
