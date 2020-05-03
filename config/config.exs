# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :sos,
  ecto_repos: [Sos.Repo]

# Configures the endpoint
config :sos, SosWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LRRweoB7m/X/lgYMYb3DHOjNNSa5RpwIFPFCT9LSGNDfs9FVQw2N6x2LBgUBKAHi",
  render_errors: [view: SosWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Sos.PubSub,
  live_view: [signing_salt: "oq5KGdOy"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
