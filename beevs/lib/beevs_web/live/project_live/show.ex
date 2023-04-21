defmodule BeevsWeb.ProjectLive.Show do
  use BeevsWeb, :live_view

  alias Beevs.WorkSpaces
  alias Beevs.WorkSpaces.Task

  @impl true
  def mount(_params, _session, socket) do
    # IO.inspect(socket)
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, params) do
    %{"id" => id} = params
    project_tasks = Enum.filter(WorkSpaces.list_tasks(), fn task -> task.project_id == id end)

    socket
    |> assign(:page_title, "Show Project")
    |> assign(:project, WorkSpaces.get_project!(id))
    |> assign(:project_tasks, project_tasks)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Project")
    |> assign(:project, WorkSpaces.get_project!(id))
  end

  defp apply_action(socket, :new_task, params) do
    socket
    |> assign(:page_title, "New Task")
    |> assign(:task, %Task{})
    |> assign(:project, WorkSpaces.get_project!(params["id"]))
  end

  defp apply_action(socket, :edit_task, %{"task_id" => task_id}) do
    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:task, WorkSpaces.get_task!(task_id))
  end

  @impl true
  def handle_event("delete", %{"task_id" => task_id}, socket) do
    task = WorkSpaces.get_task!(task_id)
    {:ok, _} = WorkSpaces.delete_task(task)
    project = WorkSpaces.get_project!(socket.assigns.project.id)

    {:noreply, socket |> assign(:project, project)}
  end
end
