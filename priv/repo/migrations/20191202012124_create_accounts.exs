defmodule Bank.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :identify, :string
      add :type, :string
      add :balance, :decimal
      add :is_active, :boolean, default: false, null: false
      add :client_id, references(:clients, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:accounts, [:client_id])
    create unique_index(:accounts, [:identify])
  end
end
