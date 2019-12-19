defmodule Bank.Guardian do
  @moduledoc """
    Esse modulo gerencia o JWT (JSON WEB TOKEN),
    que garante a autenticação e acesso dos usuários 
    a Api. 
  """

  use Guardian, otp_app: :bankapi
  alias Bank.Users
  alias Bank.Repo

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]

    resource =
      id
      |> Users.get_user!()
      |> Repo.preload([:client])

    {:ok, resource}
  end
end
