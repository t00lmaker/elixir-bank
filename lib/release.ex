defmodule Bank.Release do
  @moduledoc """
    Esse modulo guarda funções utilitarias que 
    não estao disponiveis via mix em produção. 
  """
  @app :bankapi

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
      run_seeds_for(repo)
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  def run_seeds_for(repo) do
    # Run the seed script if it exists
    seed_script = seeds_path(repo)
    if File.exists?(seed_script) do
      IO.puts "Running seed script.."
      Code.eval_file(seed_script)
    end
  end

  defp load_app do
    Application.load(@app)
    Application.ensure_started(:ssl)
  end
end
