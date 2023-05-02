defmodule Beevs.WorkSpacesTest do
  use Beevs.DataCase

  alias Beevs.WorkSpaces

  describe "projects" do
    alias Beevs.WorkSpaces.Project

    import Beevs.WorkSpacesFixtures

    @invalid_attrs %{project_name: nil}

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert WorkSpaces.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert WorkSpaces.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project" do
      valid_attrs = %{project_name: "some project_name"}

      assert {:ok, %Project{} = project} = WorkSpaces.create_project(valid_attrs)
      assert project.project_name == "some project_name"
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WorkSpaces.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      update_attrs = %{project_name: "some updated project_name"}

      assert {:ok, %Project{} = project} = WorkSpaces.update_project(project, update_attrs)
      assert project.project_name == "some updated project_name"
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = WorkSpaces.update_project(project, @invalid_attrs)
      assert project == WorkSpaces.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = WorkSpaces.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> WorkSpaces.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = WorkSpaces.change_project(project)
    end
  end

  describe "tasks" do
    alias Beevs.WorkSpaces.Task

    import Beevs.WorkSpacesFixtures

    @invalid_attrs %{assignee: nil, status: nil, task: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert WorkSpaces.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert WorkSpaces.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{assignee: "some assignee", status: "some status", task: "some task"}

      assert {:ok, %Task{} = task} = WorkSpaces.create_task(valid_attrs)
      assert task.assignee == "some assignee"
      assert task.status == "some status"
      assert task.task == "some task"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WorkSpaces.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()

      update_attrs = %{
        assignee: "some updated assignee",
        status: "some updated status",
        task: "some updated task"
      }

      assert {:ok, %Task{} = task} = WorkSpaces.update_task(task, update_attrs)
      assert task.assignee == "some updated assignee"
      assert task.status == "some updated status"
      assert task.task == "some updated task"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = WorkSpaces.update_task(task, @invalid_attrs)
      assert task == WorkSpaces.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = WorkSpaces.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> WorkSpaces.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = WorkSpaces.change_task(task)
    end
  end
end
