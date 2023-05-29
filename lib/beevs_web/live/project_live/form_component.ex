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
        <.error :if={@check_errors}></.error>
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
    attrs =
      case Cachex.get(:beevs_project_cache, {__MODULE__, project.id}) do
        {:ok, nil} -> %{}
        {:ok, attrs} -> attrs
      end

    project_changeset = WorkSpaces.change_project(project, attrs) |> Map.put(:action, :validate)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(check_errors: false)
     |> assign(:info_form, to_form(project_changeset))}
  end

  @impl true
  def handle_event("validate", %{"project" => project_params}, socket) do
    changeset =
      socket.assigns.project
      |> WorkSpaces.change_project(project_params)
      |> Map.put(:action, :validate)

    Cachex.put(:beevs_project_cache, {__MODULE__, socket.assigns.project.id}, project_params)

    Cachex.expire(
      :beevs_project_cache,
      {__MODULE__, socket.assigns.project.id},
      :timer.minutes(0)
    )

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
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  defp save_project(socket, :new, project_params) do
    case WorkSpaces.create_project(project_params) do
      {:ok, project} ->
        notify_parent({:saved, project})
        create_project_chat_room(project)

        {:noreply,
         socket
         |> put_flash(:info, "Project created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset)

    if changeset.valid? do
      assign(socket, info_form: form, check_errors: false)
    else
      assign(socket, info_form: form)
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp create_project_chat_room(project) do
    WorkSpaces.create_chatroom(%{project_id: project.id})
  end
end
