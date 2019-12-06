defmodule Bank.Guardian do
  @moduledoc """
    Esse modulo gerencia o JWT (JSON WEB TOKEN),
    que garante a autenticação e acesso dos usuários 
    a Api. 
  """
  
  use Guardian, otp_app: :bankapi

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Bank.Users.get_user!(id)
    {:ok, resource}
  end

end
