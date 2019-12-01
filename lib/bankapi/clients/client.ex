defmodule Bank.Clients.Client do
  @moduledoc false
  
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "clients" do
    field :birth_date, :string
    field :name, :string
    field :social_id, :string
    field :is_active, :boolean, default: true

    timestamps()
  end

  @doc false
  def changeset(client, attrs) do
    client
    |> cast(attrs, [:name, :social_id, :birth_date, :is_active])
    |> validate_required([:name, :social_id, :birth_date])
  end
end
