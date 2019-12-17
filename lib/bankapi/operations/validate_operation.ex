defmodule Bank.ValidateOperation do
  @moduledoc """
  Validate Operations bisiness roles.
  """
  alias Bank.Repo
  alias Bank.Operations.Operation

  @doc """
  Validate operation to type.

  ## Examples

      iex> validate(op, user)
      %{:ok, op}

      iex> list_operations(op, user)
      %{:error, %{msg: 'some message'}}

  """
  def validate(operation) do
    op = Repo.preload(operation, :account)

    with {:ok, _} <- generics(op),
         {:ok, _} <- validate_type(op) do
      {:ok, operation}
    end
  end

  defp generics(op) do
    {:ok, op}
  end

  defp validate_type(%Operation{type: "SAQUE"} = operation) do
    if has_credit?(operation) do
      {:ok, operation}
    else
      {:invalid, %{msg: "Credito insuficiente"}}
    end
  end

  defp validate_type(%Operation{type: "TRANSFERENCIA"} = operation) do
    if has_credit?(operation) do
      {:ok, operation}
    else
      {:invalid, %{msg: "Credito insuficiente"}}
    end
  end

  defp validate_type(%Operation{type: "CREDITO"} = operation) do
    {:ok, operation}
  end

  defp validate_type(_operation) do
    {:invalid, %{msg: "Operação não é válida."}}
  end

  defp has_credit?(%Operation{account: account, value: value}) do
    Decimal.compare(value, account.balance) < Decimal.new(1)
  end
end
