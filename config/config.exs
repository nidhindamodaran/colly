# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :colly,
  ecto_repos: [Colly.Repo]

# Configures the endpoint
config :colly, CollyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "s6D0H9Oyy9ncZrGI2SatQ7I1wbQFhS3JadnC+Z5g1hox9gnWU7hBagF+JNsKR1ro",
  render_errors: [view: CollyWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Colly.PubSub,
  live_view: [signing_salt: "0jimCmIr"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :colly, Colly.Scheduler,
  jobs: [
    {"@daily", {Mix.Tasks.Colly.RemoveEmptyActivities, :remove, []}}
  ]

config :colly, :remove_activities_after, %{months: 1}