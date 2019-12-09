defmodule BankWeb.AuthErrorHandler do
  import Plug.Conn

  @moduledoc """
    Gerencia os erros de Auth da api.
  """

  @default_msg "Token de autenticação é necessário para realizar essa ação."

  @invalid_token "Token inválido, novo token deve ser solicitado via login"

  def auth_error(conn, {:invalid_token, _reason}, _opts) do
    conn
    |> put_resp_content_type("text/json")
    |> send_resp(:unauthorized, Jason.encode!(%{msg: @invalid_token}))
  end

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_resp_content_type("text/json")
    |> send_resp(:unauthorized, Jason.encode!(%{msg: @default_msg}))
  end
end
