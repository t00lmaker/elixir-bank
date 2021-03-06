defmodule Bank.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false

  alias Bank.Repo
  alias Bank.Clients.Client
  alias Bank.Guardian
  alias Bank.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def user_account(user, account_id) do
    client = user.client

    if is_client?(client) && has_account?(client, account_id) do
      {:ok, user}
    else
      {:error, %{msg: "Conta não atorizada"}}
    end
  end

  defp is_client?(nil), do: false
  defp is_client?(%Client{}), do: true

  defp has_account?(client, acc_id) do
    client = Repo.preload(client, [:accounts])
    Enum.any?(client.accounts, &(&1.id == acc_id))
  end

  def authentic(username, password) do
    with %User{} = user <- Repo.get_by(User, username: username),
         {:ok, %User{} = user} <- check_password(password, user),
         {:ok, jwt, _claims} <- Guardian.encode_and_sign(user) do
      {:ok, jwt}
    else
      _ -> {:error, :unauthorized}
    end
  end

  defp check_password(password, user) do
    if Bcrypt.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :unauthorized}
    end
  end
end
