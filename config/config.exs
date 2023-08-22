# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :beevs,
  ecto_repos: [Beevs.Repo]

# Configures the endpoint
config :beevs, BeevsWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: BeevsWeb.ErrorHTML, json: BeevsWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Beevs.PubSub,
  live_view: [signing_salt: "9syX4m6L"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :beevs, Beevs.Mailer, adapter: Swoosh.Adapters.Gmail, access_token: {:system, "ya29.a0AWY7CkmUCj9oCn7OSkipf2c3YdSJAwwjXeUpC0yWUmsGft9UdgwxzapMJ_4AP5KCh-J-1MoEJMh_HkxmFCz3IuHCZ-okGxqDg7rC2VyFni1iF2Au3025hhCWKBaGcvY7DYK3dorhTuPQ7re3lX49yKkQ-ZC8aCgYKAecSARMSFQG1tDrpSZcHTjw8kS_4aGogkY8yug0163"}

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.41",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.2.4",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
