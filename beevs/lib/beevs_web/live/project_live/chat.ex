defmodule BeevsWeb.ProjectLive.Chat do
  use BeevsWeb, :live_view

  @impl true
  def mount(params, _session, socket) do
    chat_room_project = Beevs.WorkSpaces.get_project!(params["id"])
    IO.inspect(chat_room_project, label: "chat_room_project")

    message_changeset = Beevs.WorkSpaces.change_message(%Beevs.WorkSpaces.Message{})

    {:ok,
     socket
     |> assign(:chat_room_project, chat_room_project)
     |> assign(:message_form, to_form(message_changeset))}
  end

  @impl true
  def handle_event("submit_message", message_params, socket) do
    message_params =
      message_params
      |> Map.put(
        "user_id",
        socket.assigns.current_user.id
      )
      |> Map.put(
        "chatroom_id",
        socket.assigns.chat_room_project.chatroom.id
      )

    Beevs.WorkSpaces.save_message(message_params)
    IO.inspect(message_params, label: "message_params")

    {:noreply, socket}
  end

  @impl true
  def handle_event("typing", unsigned_params, socket) do
    # TODO, add restriction to profane words
    IO.inspect(unsigned_params, label: "unsigned_params2")
    {:noreply, socket}
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :message_form, to_form(changeset))
  end
end
