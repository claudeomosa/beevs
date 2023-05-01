defmodule BeevsWeb.ProjectLive.Chat do
  use BeevsWeb, :live_view

  @impl true
  def mount(params, _session, socket) do
    chat_room_project = Beevs.WorkSpaces.get_project!(params["id"])
    topic = "chat:#{chat_room_project.id}"
    if connected?(socket), do: BeevsWeb.Endpoint.subscribe(topic)

    message_changeset = Beevs.WorkSpaces.change_message(%Beevs.WorkSpaces.Message{})

    {:ok,
     socket
     |> assign(:chat_room_project, chat_room_project)
     |> assign(:message_form, to_form(message_changeset))
     |> assign(:page_title, "Chatroom")
     |> assign(:current_user, socket.assigns.current_user)
     |> assign(:topic, topic)}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
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

    BeevsWeb.Endpoint.broadcast(
      socket.assigns.topic,
      "new_message",
      message_params
    )

    case Beevs.WorkSpaces.save_message(message_params) do
      {:ok, _message} ->
        {:noreply,
         socket
         |> push_navigate(to: "/projects/#{socket.assigns.chat_room_project.id}/chatroom")
         |> assign(
           :chat_room_project,
           Beevs.WorkSpaces.get_project!(socket.assigns.chat_room_project.id)
         )}

      {:error, changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  @impl true
  def handle_event("typing", _params, socket) do
    # TODO, add restriction to profane words
    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "new_message", payload: _message}, socket) do
    {:noreply,
     socket
     |> assign(
       :chat_room_project,
       Beevs.WorkSpaces.get_project!(socket.assigns.chat_room_project.id)
     )}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :message_form, to_form(changeset))
  end
end
