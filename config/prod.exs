import Config

# Para essa aplicação o ambiente produtivo foi pensando 
# utilizando mix release. Nesse caso, as configurações serão carregas 
# de releases.exs ou de rel/config/config.ex quando utilizar o 'mix distillery.release'.

config :bankapi, BankWeb.Endpoint, url: [host: "example.com", port: 80]
# Do not print debug messages in production
config :logger, level: :info

database_url =
  "DATABASE_URL" ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :bankapi, Bank.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer("10")

secret_key_base =
  "SECRET_KEY_BASE" ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :bankapi, BankWeb.Endpoint,
  http: [:inet6, port: String.to_integer("4000")],
  secret_key_base: secret_key_base

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
config :bankapi, BankWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
