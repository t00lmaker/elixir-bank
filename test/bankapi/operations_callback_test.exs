defmodule Bank.Operations.CallbackTest do
  @moduledoc """
    Testes para a validação deoperações
  """
  use Bank.DataCase

  alias Bank.Accounts
  alias Bank.Clients
  alias Bank.Operations
  alias Bank.Operations.Callback

  @client_attrs %{
    name: "Luan Pontes",
    social_id: "3",
    birth_date: "16/10/1991",
    email: "luanpontes2@gmail.com"
  }

  @account_attrs %{
    identify: "17782-77",
    type: "A",
    balance: "1000"
  }

  @op_attrs %{
    description: "some description",
    type: "SAQUE",
    value: "120"
  }

  def client_fixture(attrs \\ %{}) do
    {:ok, client} =
      attrs
      |> Enum.into(@client_attrs)
      |> Clients.create_client()

    client
  end

  def account_fixture(attrs \\ %{}) do
    client = client_fixture()

    {:ok, account} =
      attrs
      |> Enum.into(@account_attrs)
      |> Accounts.create_account(client.id)

    account
  end

  def operation_fixture(account, attrs \\ %{}) do
    {:ok, operation} =
      attrs
      |> Enum.into(@op_attrs)
      |> Operations.create_operation(account.id)

    operation
  end

  describe "TRANSFERENCIA" do
    test "should be new opration with type CREDITO em origin account" do
      account = account_fixture()
      account2 = account_fixture(identify: "223")

      operation =
        operation_fixture(account, type: "TRANSFERENCIA", account_target_id: account2.id)

      Callback.run(operation)

      acc =
        account2.id
        |> Accounts.get_account!()
        |> Repo.preload(:operations)

      assert Enum.any?(acc.operations, &(&1.value == operation.value and &1.type == "CREDITO"))
    end

    test "should be sub value from account balance " do
      account = account_fixture()
      account2 = account_fixture(identify: "223")

      operation =
        operation_fixture(account, type: "TRANSFERENCIA", account_target_id: account2.id)

      old_balance = account.balance
      Callback.run(operation)
      acc = Accounts.get_account!(account.id)

      assert acc.balance == Decimal.sub(old_balance, operation.value)
    end

    test "should be add value from target account balance " do
      account = account_fixture()
      account2 = account_fixture(identify: "223")

      operation =
        operation_fixture(account, type: "TRANSFERENCIA", account_target_id: account2.id)

      old_balance = account2.balance
      Callback.run(operation)
      acc = Accounts.get_account!(account2.id)

      assert acc.balance == Decimal.add(old_balance, operation.value)
    end
  end

  describe "CREDITO" do
    test "should be add value from account balance " do
      account = account_fixture()
      operation = operation_fixture(account, type: "CREDITO")
      old_balance = account.balance
      Callback.run(operation)
      acc = Accounts.get_account!(account.id)

      assert acc.balance == Decimal.add(old_balance, operation.value)
    end
  end

  describe "SAQUE" do
    test "should be sub value from account balance " do
      account = account_fixture()
      operation = operation_fixture(account, type: "SAQUE")
      old_balance = account.balance
      Callback.run(operation)
      acc = Accounts.get_account!(account.id)

      assert acc.balance == Decimal.sub(old_balance, operation.value)
    end
  end
end
