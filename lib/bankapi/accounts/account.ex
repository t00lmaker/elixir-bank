defmodule Bank.Accounts.Account do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :balance, :decimal
    field :identify, :string
    field :is_active, :boolean, default: true
    field :type, :string
    belongs_to :client, Bank.Clients.Client

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:identify, :type, :balance, :is_active])
    |> validate_required([:identify, :type, :balance, :is_active])
    |> unique_constraint(:identify)
  end
end
