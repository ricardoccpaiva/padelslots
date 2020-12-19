# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :data,
  ecto_repos: [PadelSlots.Data.Repo]

# Configures the endpoint
config :webslots, PadelSlotsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6e32HpiRqajbFdjHDl4k/OTfcUG468yiLvX3QHLauDbLFM4Q/1UIILFfWcQmZU/a",
  render_errors: [view: PadelSlotsWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: PadelSlots.PubSub,
  live_view: [signing_salt: "4VJHP1Gu"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
