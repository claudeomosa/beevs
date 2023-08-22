defmodule Beevs.WorkSpaces do
  @moduledoc """
  The WorkSpaces context.
  """

  import Ecto.Query, warn: false
  alias Beevs.WorkSpaces.ProjectMember
  alias Beevs.Repo

  alias Beevs.WorkSpaces.Project
  alias Beevs.WorkSpaces.Task
  alias Beevs.WorkSpaces.Message
  alias Beevs.WorkSpaces.Chatroom
  alias Beevs.WorkSpaces.DeletedProject
  alias Beevs.WorkSpaces.DeletedTask


  @doc """
  Returns the list of projects.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  def list_projects do
    Repo.all(Project)
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id) do
    Project
    |> Repo.get!(id)
    |> Repo.preload(:tasks)
    |> Repo.preload(:user)
    |> Repo.preload(:members)
    |> Repo.preload(:project_files)
    |> Repo.preload(chatroom: [messages: [:user]])
  end

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Inserts a member into a project.

  ## Examples

      iex> insert_member(project, user)
      {:ok, %Project{}}

      iex> insert_member(project, user)
      {:error, %Ecto.Changeset{}}

  """
  def insert_project_member(project, user) do
    %ProjectMember{}
    |> ProjectMember.changeset(%{project_id: project.id, user_id: user.id})
    |> Repo.insert()
  end

  @doc """
  Deletes a member from a project.

  ## Examples

      iex> delete_project_member(project, user)
      {1, nil}

      iex> delete_project_member(project, user)
      {0, nil}
  """
  def delete_project_member(project, user) do
    Repo.delete_all(
      from(p in ProjectMember, where: p.project_id == ^project.id and p.user_id == ^user.id)
    )
  end

  @doc """
  Deletes a project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
#    Repo.delete(project)
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:deleted_project, %DeletedProject{project_name: project.project_name, user_id: project.user_id, project_description: project.project_description})
    |> Ecto.Multi.delete(:project, project)
    |> Repo.transaction()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{data: %Project{}}

  """
  def change_project(%Project{} = project, attrs \\ %{}) do
    Project.changeset(project, attrs)
  end

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Task
    |> Repo.all()
    |> Repo.preload(:project)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id) do
    Task
    |> Repo.get!(id)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    task_assignee = Beevs.Accounts.get_user!(task.user_id).email
    project_name = Beevs.WorkSpaces.get_project!(task.project_id).project_name
#    Repo.delete(task)
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:deleted_task, %DeletedTask{task_name: task.task, project_id: task.project_id, task_assignee: task_assignee, project_name: project_name})
    |> Ecto.Multi.delete(:task, task)
    |> Repo.transaction()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  @doc """
  Creates a new chatroom.

  ## Examples

      iex> create_chatroom(%{field: value})
      {:ok, %Chatroom{}}

      iex> create_chatroom(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chatroom(attrs \\ %{}) do
    %Chatroom{}
    |> Chatroom.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets a single chatroom.

  Raises `Ecto.NoResultsError` if the Chatroom does not exist.

  ## Examples

      iex> get_chatroom!(123)
      %Chatroom{}

      iex> get_chatroom!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chatroom!(id) do
    Chatroom
    |> Repo.get!(id)
    |> Repo.preload(:messages)
  end

  @doc """
  Saves a message.

  ## Examples

      iex> save_message(%{field: value})
      {:ok, %Message{}}

      iex> save_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def save_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  alias Beevs.WorkSpaces.ProjectFile

  @doc """
  Returns the list of project_files.

  ## Examples

      iex> list_project_files()
      [%ProjectFile{}, ...]

  """
  def list_project_files do
    Repo.all(ProjectFile)
  end

  @doc """
  Gets a single project_file.

  Raises `Ecto.NoResultsError` if the Project file does not exist.

  ## Examples

      iex> get_project_file!(123)
      %ProjectFile{}

      iex> get_project_file!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project_file!(id), do: Repo.get!(ProjectFile, id)

  @doc """
  Creates a project_file.

  ## Examples

      iex> create_project_file(%{field: value})
      {:ok, %ProjectFile{}}

      iex> create_project_file(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project_file(attrs \\ %{}) do
    %ProjectFile{}
    |> ProjectFile.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project_file.

  ## Examples

      iex> update_project_file(project_file, %{field: new_value})
      {:ok, %ProjectFile{}}

      iex> update_project_file(project_file, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project_file(%ProjectFile{} = project_file, attrs) do
    project_file
    |> ProjectFile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a project_file.

  ## Examples

      iex> delete_project_file(project_file)
      {:ok, %ProjectFile{}}

      iex> delete_project_file(project_file)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project_file(%ProjectFile{} = project_file) do
    Repo.delete(project_file)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project_file changes.

  ## Examples

      iex> change_project_file(project_file)
      %Ecto.Changeset{data: %ProjectFile{}}

  """
  def change_project_file(%ProjectFile{} = project_file, attrs \\ %{}) do
    ProjectFile.changeset(project_file, attrs)
  end


  @doc """
  Returns the list of deleted_projects.

  ## Examples

      iex> list_deleted_projects()
      [%DeletedProject{}, ...]

  """
  def list_deleted_projects do
    Repo.all(DeletedProject)
  end

  @doc """
  Gets a single deleted_project.

  Raises `Ecto.NoResultsError` if the Deleted project does not exist.

  ## Examples

      iex> get_deleted_project!(123)
      %DeletedProject{}

      iex> get_deleted_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_deleted_project!(id), do: Repo.get!(DeletedProject, id)

  @doc """
  Creates a deleted_project.

  ## Examples

      iex> create_deleted_project(%{field: value})
      {:ok, %DeletedProject{}}

      iex> create_deleted_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_deleted_project(attrs \\ %{}) do
    %DeletedProject{}
    |> DeletedProject.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a deleted_project.

  ## Examples

      iex> update_deleted_project(deleted_project, %{field: new_value})
      {:ok, %DeletedProject{}}

      iex> update_deleted_project(deleted_project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_deleted_project(%DeletedProject{} = deleted_project, attrs) do
    deleted_project
    |> DeletedProject.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a deleted_project.

  ## Examples

      iex> delete_deleted_project(deleted_project)
      {:ok, %DeletedProject{}}

      iex> delete_deleted_project(deleted_project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_deleted_project(%DeletedProject{} = deleted_project) do
    Repo.delete(deleted_project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking deleted_project changes.

  ## Examples

      iex> change_deleted_project(deleted_project)
      %Ecto.Changeset{data: %DeletedProject{}}

  """
  def change_deleted_project(%DeletedProject{} = deleted_project, attrs \\ %{}) do
    DeletedProject.changeset(deleted_project, attrs)
  end

  @doc """
  Returns the list of deleted_tasks.

  ## Examples

      iex> list_deleted_tasks()
      [%DeletedTask{}, ...]

  """
  def list_deleted_tasks do
    Repo.all(DeletedTask)
  end

  @doc """
  Gets a single deleted_task.

  Raises `Ecto.NoResultsError` if the Deleted task does not exist.

  ## Examples

      iex> get_deleted_task!(123)
      %DeletedTask{}

      iex> get_deleted_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_deleted_task!(id), do: Repo.get!(DeletedTask, id)

  @doc """
  Creates a deleted_task.

  ## Examples

      iex> create_deleted_task(%{field: value})
      {:ok, %DeletedTask{}}

      iex> create_deleted_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_deleted_task(attrs \\ %{}) do
    %DeletedTask{}
    |> DeletedTask.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a deleted_task.

  ## Examples

      iex> update_deleted_task(deleted_task, %{field: new_value})
      {:ok, %DeletedTask{}}

      iex> update_deleted_task(deleted_task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_deleted_task(%DeletedTask{} = deleted_task, attrs) do
    deleted_task
    |> DeletedTask.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a deleted_task.

  ## Examples

      iex> delete_deleted_task(deleted_task)
      {:ok, %DeletedTask{}}

      iex> delete_deleted_task(deleted_task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_deleted_task(%DeletedTask{} = deleted_task) do
    Repo.delete(deleted_task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking deleted_task changes.

  ## Examples

      iex> change_deleted_task(deleted_task)
      %Ecto.Changeset{data: %DeletedTask{}}

  """
  def change_deleted_task(%DeletedTask{} = deleted_task, attrs \\ %{}) do
    DeletedTask.changeset(deleted_task, attrs)
  end
end
