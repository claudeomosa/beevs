defmodule BeevsWeb.ProjectLive.Show do
  use BeevsWeb, :live_view

  alias Beevs.WorkSpaces

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    project_tasks = Enum.filter(WorkSpaces.list_tasks(), fn task -> task.project_id == id end)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:project, WorkSpaces.get_project!(id))
     |> assign(:project_tasks, project_tasks)}
  end

  defp page_title(:show), do: "Show Project"
  defp page_title(:edit), do: "Edit Project"
end
