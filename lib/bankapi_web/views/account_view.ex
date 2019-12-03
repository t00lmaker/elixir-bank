defmodule BankWeb.AccountView do
  use BankWeb, :view
  alias BankWeb.AccountView

  def render("index.json", %{accounts: accounts}) do
    %{data: render_many(accounts, AccountView, "account.json")}
  end

  def render("show.json", %{account: account}) do
    %{data: render_one(account, AccountView, "account.json")}
  end

  def render("account.json", %{account: account}) do
    %{
      id: account.id,
      identify: account.identify,
      type: account.type,
      balance: account.balance,
      is_active: account.is_active
    }
  end
end
