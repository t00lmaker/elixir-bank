defmodule Bank.Repo do
  use Ecto.Repo,
    otp_app: :bankapi,
    adapter: Ecto.Adapters.Postgres
end
