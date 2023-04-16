defmodule BeevsWeb.TaskLive.Index do
  use BeevsWeb, :live_view

  alias Beevs.WorkSpaces
  alias Beevs.WorkSpaces.Task

  @impl true
  def mount(params, _session, socket) do
    {:ok, stream(socket, :tasks, WorkSpaces.list_tasks())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:task, WorkSpaces.get_task!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Task")
    |> assign(:task, %Task{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tasks")
    |> assign(:task, nil)
  end

  @impl true
  def handle_info({BeevsWeb.TaskLive.FormComponent, {:saved, task}}, socket) do
    {:noreply, stream_insert(socket, :tasks, task)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    task = WorkSpaces.get_task!(id)
    {:ok, _} = WorkSpaces.delete_task(task)

    {:noreply, stream_delete(socket, :tasks, task)}
  end
end
