defmodule BeevsWeb.ProjectLive.Index do
  use BeevsWeb, :live_view

  alias Beevs.Accounts
  alias Beevs.WorkSpaces
  alias Beevs.WorkSpaces.Project

  @impl true
  def mount(_params, _session, socket) do
    projects =
      Enum.filter(WorkSpaces.list_projects(), fn project ->
        project.user_id == socket.assigns.current_user.id
      end)

    {:ok, stream(socket, :projects, projects)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Project")
    |> assign(:user_id, socket.assigns.current_user.id)
    |> assign(:project, WorkSpaces.get_project!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Project")
    |> assign(:project, %Project{})
    |> assign(:user_id, socket.assigns.current_user.id)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Projects")
    |> assign(:project, nil)
    |> assign(
      :collaborating_projects,
      Accounts.get_user!(socket.assigns.current_user.id).projects
    )
    |> IO.inspect()
  end

  @impl true
  def handle_event("exit_project", %{"collab_project_id" => collab_project_id}, socket) do
    IO.inspect(collab_project_id, label: "collab_project_id")

    WorkSpaces.delete_project_member(
      WorkSpaces.get_project!(collab_project_id),
      socket.assigns.current_user
    )

    {:noreply,
     socket
     |> assign(
       :collaborating_projects,
       Accounts.get_user!(socket.assigns.current_user.id).projects
     )}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    project = WorkSpaces.get_project!(id)
    {:ok, _} = WorkSpaces.delete_project(project)

    {:noreply, stream_delete(socket, :projects, project)}
  end

  @impl true
  def handle_info({BeevsWeb.ProjectLive.FormComponent, {:saved, project}}, socket) do
    {:noreply, stream_insert(socket, :projects, project)}
  end
end
