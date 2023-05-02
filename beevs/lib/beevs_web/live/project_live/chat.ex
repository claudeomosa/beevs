defmodule BeevsWeb.ProjectLive.Chat do
  use BeevsWeb, :live_view

  require Logger

  @impl true
  def mount(params, _session, socket) do
    chat_room_project = Beevs.WorkSpaces.get_project!(params["id"])
    topic = "chat#{chat_room_project.id}"

    if connected?(socket) do
      BeevsWeb.Endpoint.subscribe(topic)
      BeevsWeb.Presence.track(self(), topic, socket.assigns.current_user.id, %{})
    end

    message_changeset = Beevs.WorkSpaces.change_message(%Beevs.WorkSpaces.Message{})

    {:ok,
     socket
     |> assign(:chat_room_project, chat_room_project)
     |> assign(:message_form, to_form(message_changeset))
     |> assign(:page_title, "Chatroom")
     |> assign(:active_userlist, [])
     |> assign(:current_user, socket.assigns.current_user)
     |> assign(:topic, topic)
     |> IO.inspect()}
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

  @impl true
  def handle_info(%{event: "presence_diff", payload: %{joins: joins, leaves: leaves}}, socket) do
    _join_message =
      joins
      |> Map.keys()
      |> Enum.map(fn user_id ->
        "#{Beevs.Accounts.get_user!(user_id).username}" <> " joined"
      end)

    _leave_message =
      leaves
      |> Map.keys()
      |> Enum.map(fn user_id ->
        "#{Beevs.Accounts.get_user!(user_id).username}" <> " left"
      end)

    active_userlist =
      BeevsWeb.Presence.list(socket.assigns.topic)
      |> Map.keys()
      |> Enum.map(fn user_id ->
        Beevs.Accounts.get_user!(user_id)
      end)

    {:noreply, socket |> assign(:active_userlist, active_userlist)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :message_form, to_form(changeset))
  end
end
