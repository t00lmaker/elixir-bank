defmodule Bank.Clients.Client do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "clients" do
    field :birth_date, :string
    field :name, :string
    field :social_id, :string

    timestamps()
  end

  @doc false
  def changeset(client, attrs) do
    client
    |> cast(attrs, [:name, :social_id, :birth_date])
    |> validate_required([:name, :social_id, :birth_date])
  end
end
