defmodule BeevsWeb.TaskLive.Index do
  alias Beevs.WorkSpaces
  use BeevsWeb, :live_view
  @impl true
  def mount(_params, _session, socket) do
    my_tasks =
      Enum.filter(WorkSpaces.list_tasks(), fn task ->
        task.user_id == socket.assigns.current_user.id
      end)

    IO.inspect(my_tasks)
    {:ok, socket |> assign(:my_tasks, my_tasks)}
  end
end
