defmodule BankWeb.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :admin,
    error_handler: BankWeb.AuthErrorHandler,
    module: Bank.Guardian

  @moduledoc """
    Define plugs para serem utilizados no routes da aplicação.
  """

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
