defmodule BeevsWeb.ProjectLive.FormComponent do
  use BeevsWeb, :live_component

  alias Beevs.WorkSpaces

  @impl true
  def render(assigns) do
    ~H"""
    <div class="">
      <.header>
        <%= @title %>
      </.header>

      <.simple_form
        for={@info_form}
        id="project-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@info_form[:project_name]} type="text" label="Project name" />
        <.input field={@info_form[:project_description]} type="textarea" label="Project description" />
        <.input field={@info_form[:user_id]} type="hidden" value={@user_id} />
        <:actions>
          <.button phx-disable-with="Saving...">Save Changes</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{project: project} = assigns, socket) do
    project_changeset = WorkSpaces.change_project(project)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:info_form, to_form(project_changeset))}
  end

  @impl true
  def handle_event("validate", %{"project" => project_params}, socket) do
    changeset =
      socket.assigns.project
      |> WorkSpaces.change_project(project_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"project" => project_params}, socket) do
    save_project(socket, socket.assigns.action, project_params)
  end

  defp save_project(socket, :edit, project_params) do
    case WorkSpaces.update_project(socket.assigns.project, project_params) do
      {:ok, project} ->
        notify_parent({:saved, project})

        {:noreply,
         socket
         |> put_flash(:info, "Project updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_project(socket, :new, project_params) do
    case WorkSpaces.create_project(project_params) do
      {:ok, project} ->
        notify_parent({:saved, project})
        create_project_chat_room()

        {:noreply,
         socket
         |> put_flash(:info, "Project created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp create_project_chat_room() do
    IO.puts("Creating chat room for project")
  end
end
