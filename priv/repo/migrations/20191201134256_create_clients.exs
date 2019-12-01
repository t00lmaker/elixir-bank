defmodule Bank.Repo.Migrations.CreateClients do
  use Ecto.Migration

  def change do
    create table(:clients, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :social_id, :string
      add :birth_date, :string

      timestamps()
    end

  end
end
