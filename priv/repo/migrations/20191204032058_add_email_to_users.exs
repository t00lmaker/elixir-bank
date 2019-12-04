defmodule Bank.Repo.Migrations.AddEmailToUsers do
  use Ecto.Migration

  def change do
    alter table(:clients) do
      add :email, :string, null: false
    end
  end
end
