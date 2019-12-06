defmodule BankWeb.AuthController do
  use BankWeb, :controller

  alias Bank.Users

  action_fallback BankWeb.FallbackController

  @unauth_msg "O username e/ou password não é válido"

  def login(conn, %{"username" => username, "password" => password }) do
    case Users.authentic(username, password) do
      {:ok, jwt} -> conn |> render("jwt.json", jwt: jwt)
      {:error, _} -> {:error, %{status: :unauthorized, msg: @unauth_msg}}
    end
  end
end
