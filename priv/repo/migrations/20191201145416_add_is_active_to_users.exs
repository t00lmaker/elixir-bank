defmodule Bank.Repo.Migrations.AddIsActiveToUsers do
  use Ecto.Migration

  def change do
    alter table(:clients) do
      add :is_active, :boolean, default: true, null: false
    end
  end
end
