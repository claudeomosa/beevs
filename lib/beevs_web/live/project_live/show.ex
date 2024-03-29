defmodule BeevsWeb.ProjectLive.Show do
  use BeevsWeb, :live_view

  alias Beevs.Accounts
  alias Beevs.WorkSpaces
  alias Beevs.WorkSpaces.Task
  alias Beevs.WorkSpaces.ProjectFile

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, params) do
    %{"id" => id} = params

    socket
    |> assign(:page_title, "Show Project")
    |> assign(:project, WorkSpaces.get_project!(id))
    |> assign(tasks_view: :table)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Project")
    |> assign(:project, WorkSpaces.get_project!(id))
    |> assign(tasks_view: :table)
  end

  defp apply_action(socket, :new_task, params) do
    project = WorkSpaces.get_project!(params["id"])

    assignee_options =
      Enum.map(project.members, fn member ->
        {member.email, member.id}
      end)

    assignee_options = [
      {project.user.email, project.user.id}
      | assignee_options
    ]

    socket
    |> assign(:page_title, "New Task")
    |> assign(:task, %Task{})
    |> assign(:project, project)
    |> assign(tasks_view: :table)
    |> assign(:assignee_options, assignee_options)
  end

  defp apply_action(socket, :edit_task, %{"task_id" => task_id}) do
    task = WorkSpaces.get_task!(task_id)
    project = WorkSpaces.get_project!(task.project_id)

    assignee_options =
      Enum.map(project.members, fn member ->
        {member.email, member.id}
      end)

    assignee_options = [
      {project.user.email, project.user.id}
      | assignee_options
    ]

    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:project, project)
    |> assign(tasks_view: :table)
    |> assign(:assignee_options, assignee_options)
    |> assign(:task, task)
  end

  defp apply_action(socket, :edit_collaborators, %{"id" => id}) do
    socket
    |> assign(:page_title, "Collaborators")
    |> assign(:project, WorkSpaces.get_project!(id))
    |> assign(tasks_view: :table)
  end

  # defp apply_action(socket, :project_files, %{"id" => id}) do
  #   project_files = WorkSpaces.list_project_files()
  #                   |> Enum.filter(fn project_file ->
  #                     project_file.project_id == id
  #                   end)
  #   socket
  #   |> assign(:page_title, "Project Files")
  #   |> assign(:project, WorkSpaces.get_project!(id))
  #   |> assign(tasks_view: :table)
  #   |> assign(:project_files, project_files)
  #   |> allow_upload(:project_file, accept: ~w(.pdf .doc .docx .ppt .pptx .txt .png .jpg .jpeg .zip .rar .tar .gz .7z), max_entries: 2)
  # end

  @impl true
  def handle_event("delete", %{"task_id" => task_id}, socket) do
    task = WorkSpaces.get_task!(task_id)
    {:ok, _} = WorkSpaces.delete_task(task)
    project = WorkSpaces.get_project!(socket.assigns.project.id)

    {:noreply, socket |> assign(:project, project)}
  end

  @impl true
  def handle_event("delete_collaborator", %{"member_id" => member_id}, socket) do
    if socket.assigns.project.user_id == socket.assigns.current_user.id do
      WorkSpaces.delete_project_member(socket.assigns.project, Accounts.get_user!(member_id))
    else
      {:error, "You can't delete a collabirator if you are not the owner of the project"}
    end

    project = WorkSpaces.get_project!(socket.assigns.project.id)

    {:noreply, socket |> assign(:project, project)}
  end

  @impl true
  def handle_event("change_tasks_view", %{"tasks_view" => tasks_view}, socket) do
    {:noreply, socket |> assign(:tasks_view, String.to_atom(tasks_view))}
  end
end
