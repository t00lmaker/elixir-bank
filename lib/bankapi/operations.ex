defmodule Bank.Operations do
  @moduledoc """
  The Operations context.
  """

  import Ecto.Query, warn: false
  alias Bank.Repo
  alias Bank.Accounts.Account
  alias Bank.Operations.Operation
  alias Bank.ValidateOperation

  @doc """
  Returns the list of operations.

  ## Examples

      iex> list_operations()
      [%Operation{}, ...]

  """
  def list_operations do
    Repo.all(Operation)
  end

  @doc """
  Returns the list of operations to especify account_id.

  ## Examples

      iex> list_operations(account_id)
      [%Operation{}, ...]

  """
  def list_operations(account_id) do
    Operation
    |> where(account_id: ^account_id)
    |> Repo.all()
  end

  @doc """
  Gets a single operation.

  Raises `Ecto.NoResultsError` if the Operation does not exist.

  ## Examples

      iex> get_operation!(123)
      %Operation{}

      iex> get_operation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_operation!(id), do: Repo.get!(Operation, id)

  @doc """
  Creates a operation.

  ## Examples

      iex> create_operation(%{field: value})
      {:ok, %Operation{}}

      iex> create_operation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_valid_operation(attrs \\ %{}, acc_id) do
    {_, result} =
      Repo.transaction(fn ->
        with {:ok, %Operation{} = op} <- create_operation(attrs, acc_id),
             {:ok, %Operation{} = op} <- validate(op) do
          {:ok, op}
        else
          error -> Repo.rollback(error)
        end
      end)

    result
  end

  def create_operation(attrs \\ %{}, account_id) do
    Account
    |> Repo.get!(account_id)
    |> Repo.preload(client: [:user])
    |> Ecto.build_assoc(:operations)
    |> Operation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Validate operation to type.

  ## Examples

      iex> validate(op, user)
      %{:ok, op}

      iex> list_operations(op, user)
      %{:error, %{msg: 'some message'}}

  """
  def validate(%Operation{} = operation) do
    ValidateOperation.validate(operation)
  end

  @doc """
  Updates a operation.

  ## Examples

      iex> update_operation(operation, %{field: new_value})
      {:ok, %Operation{}}

      iex> update_operation(operation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_operation(%Operation{} = operation, attrs) do
    operation
    |> Operation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Operation.

  ## Examples

      iex> delete_operation(operation)
      {:ok, %Operation{}}

      iex> delete_operation(operation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_operation(%Operation{} = operation) do
    Repo.delete(operation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking operation changes.

  ## Examples

      iex> change_operation(operation)
      %Ecto.Changeset{source: %Operation{}}

  """
  def change_operation(%Operation{} = operation) do
    Operation.changeset(operation, %{})
  end
end
