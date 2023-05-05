defmodule Beevs.Repo do
  use Ecto.Repo,
    otp_app: :beevs,
    adapter: Ecto.Adapters.Postgres
end
