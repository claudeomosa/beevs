defmodule BeevsWeb.ProjectLive.CollaboratorsComponent do
  alias Beevs.WorkSpaces
  use BeevsWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to edit your project collaborators.</:subtitle>
      </.header>
      <.simple_form for={} id="task-form" phx-target={@myself} phx-submit="add_collaborator">
        <.input
          name="collaborator_email_or_username"
          type="text"
          label="New Collaborator's email"
          value={}
        />
        <:actions>
          <.button phx-disable-with="Adding...">Add</.button>
        </:actions>
      </.simple_form>
      <.table rows={@project.members} id="members">
        <:col :let={member} label="UserName">
          <%= member.username %>
        </:col>
        <:col :let={member} label="Email">
          <%= member.email %>
        </:col>
        <:action :let={member}>
          <.link
            phx-click={
              JS.push("delete_collaborator", value: %{member_id: member.id})
              |> hide("##{member.id}")
            }
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end

  @impl true
  def handle_event(
        "add_collaborator",
        %{"collaborator_email_or_username" => email_or_username},
        socket
      ) do
    if String.contains?(email_or_username, "@") do
      case Beevs.Accounts.get_user_by_email(to_string(email_or_username)) do
        nil ->
          {:noreply,
           socket |> assign(:error, "User not found") |> put_flash(:error, "User not found")}

        user ->
          notify_parent({:collaborator_added, user})
          WorkSpaces.insert_project_member(socket.assigns.project, user)

          {:noreply,
           socket
           |> put_flash(:info, "Collaborator added successfully")
           |> assign(:error, nil)
           |> assign(:collaborator_email_or_username, "")
           |> push_patch(to: socket.assigns.after_add_patch)}
      end
    else
      {:noreply, socket |> assign(:error, "User not found")}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
