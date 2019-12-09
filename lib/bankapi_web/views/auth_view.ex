defmodule BankWeb.AuthView do
  use BankWeb, :view
  alias BankWeb.AuthView

  def render("index.json", %{auths: auths}) do
    %{data: render_many(auths, AuthView, "auth.json")}
  end

  def render("show.json", %{auth: auth}) do
    %{data: render_one(auth, AuthView, "auth.json")}
  end

  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end
end
