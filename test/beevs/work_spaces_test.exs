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

  describe "project_files" do
    alias Beevs.WorkSpaces.ProjectFile

    import Beevs.WorkSpacesFixtures

    @invalid_attrs %{description: nil}

    test "list_project_files/0 returns all project_files" do
      project_file = project_file_fixture()
      assert WorkSpaces.list_project_files() == [project_file]
    end

    test "get_project_file!/1 returns the project_file with given id" do
      project_file = project_file_fixture()
      assert WorkSpaces.get_project_file!(project_file.id) == project_file
    end

    test "create_project_file/1 with valid data creates a project_file" do
      valid_attrs = %{description: "some description"}

      assert {:ok, %ProjectFile{} = project_file} = WorkSpaces.create_project_file(valid_attrs)
      assert project_file.description == "some description"
    end

    test "create_project_file/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WorkSpaces.create_project_file(@invalid_attrs)
    end

    test "update_project_file/2 with valid data updates the project_file" do
      project_file = project_file_fixture()
      update_attrs = %{description: "some updated description"}

      assert {:ok, %ProjectFile{} = project_file} = WorkSpaces.update_project_file(project_file, update_attrs)
      assert project_file.description == "some updated description"
    end

    test "update_project_file/2 with invalid data returns error changeset" do
      project_file = project_file_fixture()
      assert {:error, %Ecto.Changeset{}} = WorkSpaces.update_project_file(project_file, @invalid_attrs)
      assert project_file == WorkSpaces.get_project_file!(project_file.id)
    end

    test "delete_project_file/1 deletes the project_file" do
      project_file = project_file_fixture()
      assert {:ok, %ProjectFile{}} = WorkSpaces.delete_project_file(project_file)
      assert_raise Ecto.NoResultsError, fn -> WorkSpaces.get_project_file!(project_file.id) end
    end

    test "change_project_file/1 returns a project_file changeset" do
      project_file = project_file_fixture()
      assert %Ecto.Changeset{} = WorkSpaces.change_project_file(project_file)
    end
  end

  describe "deleted_projects" do
    alias Beevs.WorkSpaces.DeletedProject

    import Beevs.WorkSpacesFixtures

    @invalid_attrs %{}

    test "list_deleted_projects/0 returns all deleted_projects" do
      deleted_project = deleted_project_fixture()
      assert WorkSpaces.list_deleted_projects() == [deleted_project]
    end

    test "get_deleted_project!/1 returns the deleted_project with given id" do
      deleted_project = deleted_project_fixture()
      assert WorkSpaces.get_deleted_project!(deleted_project.id) == deleted_project
    end

    test "create_deleted_project/1 with valid data creates a deleted_project" do
      valid_attrs = %{}

      assert {:ok, %DeletedProject{} = deleted_project} = WorkSpaces.create_deleted_project(valid_attrs)
    end

    test "create_deleted_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WorkSpaces.create_deleted_project(@invalid_attrs)
    end

    test "update_deleted_project/2 with valid data updates the deleted_project" do
      deleted_project = deleted_project_fixture()
      update_attrs = %{}

      assert {:ok, %DeletedProject{} = deleted_project} = WorkSpaces.update_deleted_project(deleted_project, update_attrs)
    end

    test "update_deleted_project/2 with invalid data returns error changeset" do
      deleted_project = deleted_project_fixture()
      assert {:error, %Ecto.Changeset{}} = WorkSpaces.update_deleted_project(deleted_project, @invalid_attrs)
      assert deleted_project == WorkSpaces.get_deleted_project!(deleted_project.id)
    end

    test "delete_deleted_project/1 deletes the deleted_project" do
      deleted_project = deleted_project_fixture()
      assert {:ok, %DeletedProject{}} = WorkSpaces.delete_deleted_project(deleted_project)
      assert_raise Ecto.NoResultsError, fn -> WorkSpaces.get_deleted_project!(deleted_project.id) end
    end

    test "change_deleted_project/1 returns a deleted_project changeset" do
      deleted_project = deleted_project_fixture()
      assert %Ecto.Changeset{} = WorkSpaces.change_deleted_project(deleted_project)
    end
  end

  describe "deleted_tasks" do
    alias Beevs.WorkSpaces.DeletedTask

    import Beevs.WorkSpacesFixtures

    @invalid_attrs %{}

    test "list_deleted_tasks/0 returns all deleted_tasks" do
      deleted_task = deleted_task_fixture()
      assert WorkSpaces.list_deleted_tasks() == [deleted_task]
    end

    test "get_deleted_task!/1 returns the deleted_task with given id" do
      deleted_task = deleted_task_fixture()
      assert WorkSpaces.get_deleted_task!(deleted_task.id) == deleted_task
    end

    test "create_deleted_task/1 with valid data creates a deleted_task" do
      valid_attrs = %{}

      assert {:ok, %DeletedTask{} = deleted_task} = WorkSpaces.create_deleted_task(valid_attrs)
    end

    test "create_deleted_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WorkSpaces.create_deleted_task(@invalid_attrs)
    end

    test "update_deleted_task/2 with valid data updates the deleted_task" do
      deleted_task = deleted_task_fixture()
      update_attrs = %{}

      assert {:ok, %DeletedTask{} = deleted_task} = WorkSpaces.update_deleted_task(deleted_task, update_attrs)
    end

    test "update_deleted_task/2 with invalid data returns error changeset" do
      deleted_task = deleted_task_fixture()
      assert {:error, %Ecto.Changeset{}} = WorkSpaces.update_deleted_task(deleted_task, @invalid_attrs)
      assert deleted_task == WorkSpaces.get_deleted_task!(deleted_task.id)
    end

    test "delete_deleted_task/1 deletes the deleted_task" do
      deleted_task = deleted_task_fixture()
      assert {:ok, %DeletedTask{}} = WorkSpaces.delete_deleted_task(deleted_task)
      assert_raise Ecto.NoResultsError, fn -> WorkSpaces.get_deleted_task!(deleted_task.id) end
    end

    test "change_deleted_task/1 returns a deleted_task changeset" do
      deleted_task = deleted_task_fixture()
      assert %Ecto.Changeset{} = WorkSpaces.change_deleted_task(deleted_task)
    end
  end
end
