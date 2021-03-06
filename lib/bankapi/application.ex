defmodule Bank.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Bank.Repo,
      # Start the endpoint when the application starts
      BankWeb.Endpoint,
      # Starts a worker by calling: Bank.Worker.start_link(arg)
      # {Bank.Worker, arg},
      # Supervisor to Email sender and etc ...
      supervisor(Task.Supervisor, [[name: Bank.TaskSupervisor]])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bank.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BankWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
