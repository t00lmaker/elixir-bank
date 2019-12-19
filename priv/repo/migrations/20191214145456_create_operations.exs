defmodule Bank.Repo.Migrations.CreateOperations do
  use Ecto.Migration

  def change do
    create table(:operations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :description, :text
      add :type, :string
      add :value, :decimal
      add :is_consolidaded, :boolean, default: false, null: false
      add :account_id, references(:accounts, on_delete: :nothing, type: :binary_id)
      add :operation_origin_id, references(:operations, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:operations, [:account_id])
    create index(:operations, [:operation_origin_id])
  end
end
