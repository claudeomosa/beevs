defmodule BeevsWeb.TaskLive.FormComponent do
  use BeevsWeb, :live_component

  alias Beevs.WorkSpaces

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage task records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="task-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:task]} type="text" label="Task" />
        <.input
          field={@form[:user_id]}
          type="select"
          label="Assignee"
          multiple={false}
          id="task-assignee"
          options={@assignee_options}
        />
        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          multiple={false}
          id="task-status"
          options={
            if @action == :edit_task,
              do: [
                ToDo: "todo",
                Ongoing: "ongoing",
                Completed: "completed"
              ],
              else: [
                ToDo: "todo",
                Ongoing: "ongoing"
              ]
          }
        >
        </.input>
        <.input field={@form[:start_date]} type="date" label="Start Date" />
        <.input field={@form[:due_date]} type="date" label="Due Date" />
        <%!-- <.input field={@form[:priority]} type="number" label="Priority - [0 - LOW, 1 - MID, 2 - HIGH]" /> --%>
        <.input
          type="select"
          label="Priority"
          field={@form[:priority]}
          multiple={false}
          id="task-priority"
          options={[
            Low: 0,
            Mid: 1,
            High: 2
          ]}
        />
        <.input field={@form[:project_id]} type="hidden" value={@project.id} />
        <:actions>
          <.button phx-disable-with="Saving...">Save Task</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{task: task} = assigns, socket) do
    changeset = WorkSpaces.change_task(task)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"task" => task_params}, socket) do
    changeset =
      socket.assigns.task
      |> WorkSpaces.change_task(task_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"task" => task_params}, socket) do
    save_task(socket, socket.assigns.action, task_params)
  end

  defp save_task(socket, :edit_task, task_params) do
    case WorkSpaces.update_task(socket.assigns.task, task_params) do
      {:ok, task} ->
        notify_parent({:saved, task})

        {:noreply,
         socket
         |> put_flash(:info, "Task updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_task(socket, :new_task, task_params) do
    case WorkSpaces.create_task(task_params) do
      {:ok, task} ->
        notify_parent({:saved, task})

        {:noreply,
         socket
         |> put_flash(:info, "Task created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
