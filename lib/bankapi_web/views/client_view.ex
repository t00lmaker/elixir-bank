defmodule BankWeb.ClientView do
  use BankWeb, :view
  alias BankWeb.ClientView

  def render("index.json", %{clients: clients}) do
    %{data: render_many(clients, ClientView, "client.json")}
  end

  def render("show.json", %{client: client}) do
    %{data: render_one(client, ClientView, "client.json")}
  end

  def render("client.json", %{client: client}) do
    %{
      id: client.id,
      name: client.name,
      social_id: client.social_id,
      birth_date: client.birth_date,
      is_active: client.is_active,
      email: client.email
    }
  end
end
