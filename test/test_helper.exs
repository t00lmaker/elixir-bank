ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Bank.Repo, :manual)

defmodule Bank.AuthTestHelper do
  alias Bank.Guardian
  alias Bank.Users
  alias Bank.Users.User

  @valid_attrs %{
    password: "password",
    password_confirmation: "password",
    username: "username"
  }

  def create_user(attrs \\ []) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Users.create_user()

    user
  end

  def api_token(%User{} = user) do
    Guardian.encode_and_sign(user)
  end

  def api_token() do
    Guardian.encode_and_sign(create_user())
  end
end
