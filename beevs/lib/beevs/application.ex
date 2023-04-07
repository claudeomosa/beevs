defmodule Beevs.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BeevsWeb.Telemetry,
      # Start the Ecto repository
      Beevs.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Beevs.PubSub},
      # Start Finch
      {Finch, name: Beevs.Finch},
      # Start the Endpoint (http/https)
      BeevsWeb.Endpoint
      # Start a worker by calling: Beevs.Worker.start_link(arg)
      # {Beevs.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Beevs.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BeevsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
