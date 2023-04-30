defmodule BeevsWeb.ProjectLive.Chat do
  use BeevsWeb, :live_view

  def mount(params, _session, socket) do
    chat_room_project = Beevs.WorkSpaces.get_project!(params["id"])
    IO.inspect(chat_room_project, label: "chat_room_project")
    {:ok, socket |> assign(:chat_room_project, chat_room_project)}
  end
end
