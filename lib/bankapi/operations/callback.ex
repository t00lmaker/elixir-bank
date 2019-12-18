defmodule Bank.Operations.CallBack do
  @moduledoc """
  Validate Operations bisiness roles.
  """

  alias Bank.Accounts.Account
  alias Bank.Operations
  alias Bank.Operations.Notify
  alias Bank.Operations.Operation
  alias Bank.Repo

  @doc """
  Validate operation to type.

  ## Examples

      iex> validate(op, user)
      %{:ok, op}

      iex> list_operations(op, user)
      %{:error, %{msg: 'some message'}}

  """
  def run(%Operation{} = operation) do
    op = Repo.preload(operation, :account)

    with %Account{} = _account <- update_value(op, op.account),
         {:ok, %Operation{} = operation} <- callback_type(op) do
      {:ok, operation}
    else
      error -> {:error, error}
    end
  end

  defp callback_type(%Operation{type: "SAQUE"} = operation) do
    Notify.send(operation)
    {:ok, operation}
  end

  defp callback_type(%Operation{type: "TRANSFERENCIA"} = operation) do
    attrs = template_trans(operation)
    other_account = operation.account_target_id

    {:ok, %Operation{} = new_op} = Operations.create_operation(attrs, other_account)

    Operations.assoc_origin(new_op, operation)

    run(new_op)
  end

  defp callback_type(%Operation{type: "CREDITO"} = operation) do
    {:ok, operation}
  end

  defp callback_type(_operation) do
    {:invalid, %{msg: "Operação não é válida."}}
  end

  defp update_value(operation, account) do
    operation
    |> update_balance(account)
    |> Repo.update!()
  end

  defp update_balance(%Operation{type: "CREDITO"} = op, acc) do
    Account.changeset(acc, %{balance: Decimal.add(acc.balance, op.value)})
  end

  defp update_balance(%Operation{} = op, acc) do
    Account.changeset(acc, %{balance: Decimal.sub(acc.balance, op.value)})
  end

  defp template_trans(operation) do
    %{
      type: "CREDITO",
      value: operation.value,
      description: "credito por transferencia"
    }
  end
end
