# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :bankapi,
  namespace: Bank,
  ecto_repos: [Bank.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :bankapi, BankWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Q2+Z9ZRBfk5LfTaJ/A0UxSKp31Xu4zzwOZsn+NlKfpe93FoecBANPoLhdXekkU3w",
  render_errors: [view: BankWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Bank.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Guardian config
config :bankapi, Bank.Guardian,
  issuer: "bankapi",
  secret_key: "u42lmqps7xcVl5FSfwa985zht1EaKO3/6BtMY3HJtH34wvAlEhclnqKm11Xbm5MN"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
