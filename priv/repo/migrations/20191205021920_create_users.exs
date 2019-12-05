defmodule Bank.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :username, :string
      add :password_hash, :string
      add :client_id, references(:clients, on_delete: :nothing, type: :binary_id)
      
      timestamps()
    end

    create unique_index(:users, [:username])
  end
end
