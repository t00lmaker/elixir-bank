defmodule BankWeb.Router do
  use BankWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BankWeb do
    pipe_through :api

    resources "/accounts", AccountController, except: [:new, :edit]
    resources "/clients", ClientController, except: [:new, :edit]
    resources "/users", UserController, only: [:create, :show]
  end
end
