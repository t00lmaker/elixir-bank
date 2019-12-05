defmodule Bank.Clients.Client do
  @moduledoc false

  use Ecto.Schema
  alias Bank.Repo
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "clients" do
    field :birth_date, :string
    field :name, :string
    field :social_id, :string
    field :is_active, :boolean, default: true
    field :email, :string
    
    has_many :accounts, Bank.Accounts.Account
    has_one :user, Bank.Users.User, on_replace: :mark_as_invalid
    
    timestamps()
  end

  @doc false
  def changeset(client, attrs) do
    client
    |> Repo.preload(:user)
    |> cast(attrs, [:name, :social_id, :birth_date, :is_active, :email])
    |> cast_assoc(:user, with: &Bank.Users.User.changeset/2)
    |> validate_format(:email, ~r/@/) 
    |> validate_required([:name, :social_id, :birth_date, :email])
  end
end
