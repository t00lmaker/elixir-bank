defmodule Bank.Operations.Operation do
  @moduledoc """
    Representação de uma operação bancaria 
    que pode ser definida pelo tipo.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "operations" do
    field :description, :string
    field :is_consolidaded, :boolean, default: false
    field :type, :string
    field :value, :decimal

    field :account_target_id, :binary, virtual: true

    belongs_to :account, Bank.Accounts.Account
    belongs_to :operation_origin, Bank.Operations.Operation

    timestamps()
  end

  @doc false
  def changeset(operation, attrs) do
    operation
    |> cast(attrs, [:description, :type, :value, :is_consolidaded, :account_target_id])
    |> validate_required([:description, :type, :value, :is_consolidaded])
  end
end
