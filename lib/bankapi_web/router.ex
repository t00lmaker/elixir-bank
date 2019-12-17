defmodule BankWeb.Router do
  use BankWeb, :router

  pipeline :api_auth do
    plug BankWeb.AuthPipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Public
  scope "/api", BankWeb do
    pipe_through [:api, :api_auth]

    post "/login", AuthController, :login
  end

  # Private 
  scope "/api", BankWeb do
    pipe_through [:api, :api_auth, :ensure_auth]

    resources "/accounts", AccountController, except: [:new, :edit] do
      resources "/operations", OperationController, except: [:new, :edit]
    end

    get "operations/:period", OperationController, :total

    resources "/clients", ClientController, except: [:new, :edit]
    resources "/users", UserController, except: [:new, :edit]
  end
end
