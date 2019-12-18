defmodule Bank.ValidationOperationTest do
  @moduledoc """
    Testes para Validação de Operações.
  """
  
  use Bank.DataCase

  alias Bank.Accounts
  alias Bank.Clients
  alias Bank.Operations
  alias Bank.Operations.Validate

  @client_attrs %{
    name: "Luan Pontes",
    social_id: "3",
    birth_date: "16/10/1991",
    email: "luanpontes2@gmail.com"
  }

  @account_attrs %{
    identify: "17782-77",
    type: "A",
    balance: 1000
  }

  @op_attrs %{description: "some description", type: "SAQUE", value: "120.5"}

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

  def operation_fixture() do
    account = account_fixture()
    operation_fixture(account)
  end

  describe "generics role validate operation" do
    test "should be generics roles" do
      operation = operation_fixture()
      assert {:ok, operation} == Validate.validate(operation)
    end
  end

  describe "validate operation SAQUE" do
    test "permitided when balance > value" do
      account = account_fixture()
      operation = operation_fixture(account, %{value: 999})

      assert {:ok, operation} == Validate.validate(operation)
    end

    test "permitided when balance = value" do
      account = account_fixture()
      operation = operation_fixture(account, %{value: 1000})

      assert {:ok, operation} == Validate.validate(operation)
    end

    test "not permitided when balance < value" do
      account = account_fixture()
      op = operation_fixture(account, %{value: 1001})
      msg = "Credito insuficiente"
      assert {:invalid, %{msg: msg}} == Validate.validate(op)
    end
  end

  describe "validate operation TRANSFERENCIA" do
    test "permitided when balance > value" do
      account = account_fixture()
      operation = operation_fixture(account, %{type: "TRANSFERENCIA", value: 999})

      assert {:ok, operation} == Validate.validate(operation)
    end

    test "permitided when balance = value" do
      account = account_fixture()
      operation = operation_fixture(account, %{type: "TRANSFERENCIA", value: 1000})

      assert {:ok, operation} == Validate.validate(operation)
    end

    test "not permitided when balance < value" do
      account = account_fixture()
      op = operation_fixture(account, %{type: "TRANSFERENCIA", value: 1001})
      msg = "Credito insuficiente"
      assert {:invalid, %{msg: msg}} == Validate.validate(op)
    end
  end

  describe "validate operation CREDITO" do
    test "should be a valid operation" do
      account = account_fixture()
      operation = operation_fixture(account, %{type: "CREDITO"})

      assert {:ok, operation} == Validate.validate(operation)
    end
  end
end
