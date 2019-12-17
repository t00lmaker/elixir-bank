defmodule Bank.OperationsTest do
  use Bank.DataCase

  alias Bank.Clients
  alias Bank.Accounts
  alias Bank.Operations

  describe "operations" do
    alias Bank.Operations.Operation

    @client_attrs %{
      name: "Luan Pontes",
      social_id: "3",
      birth_date: "16/10/1991",
      email: "luanpontes2@gmail.com"
    }

    @account_attrs %{
      identify: "17782-77",
      type: "A",
      balance: 100
    }

    @valid_attrs %{description: "some description", type: "some type", value: "120.5"}
    @update_attrs %{
      description: "some updated description",
      type: "some updated type",
      value: "456.7"
    }
    @invalid_attrs %{description: nil, type: nil, value: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, client} = Clients.create_client(@client_attrs)

      {:ok, account} =
        attrs
        |> Enum.into(@account_attrs)
        |> Accounts.create_account(client.id)

      account
    end

    def operation_fixture() do
      operation_fixture(account_fixture())
    end

    def operation_fixture(account, attrs \\ %{}) do
      {:ok, operation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Operations.create_operation(account.id)

      operation
    end

    test "list_operations/1 returns all operations to espefic account" do
      account1 = account_fixture(%{identify: "account1"})
      account2 = account_fixture(%{identify: "account2"})

      operation_acc_1 = operation_fixture(account1)
      operation_acc_2 = operation_fixture(account2)
      operation2_acc_2 = operation_fixture(account2)

      assert Operations.list_operations(account1.id) == [operation_acc_1]
      assert Operations.list_operations(account2.id) == [operation_acc_2, operation2_acc_2]
    end

    test "list_operations/0 returns all operations" do
      operation = operation_fixture()
      assert Operations.list_operations() == [operation]
    end

    test "get_operation!/1 returns the operation with given id" do
      operation = operation_fixture()
      assert Operations.get_operation!(operation.id) == operation
    end

    test "create_operation/1 with valid data creates a operation" do
      account = account_fixture()

      assert {:ok, %Operation{} = operation} =
               Operations.create_operation(@valid_attrs, account.id)

      assert operation.description == "some description"
      assert operation.type == "some type"
      assert operation.value == Decimal.new("120.5")
    end

    test "create_operation/1 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Operations.create_operation(@invalid_attrs, account.id)
    end

    test "update_operation/2 with valid data updates the operation" do
      operation = operation_fixture()

      assert {:ok, %Operation{} = operation} =
               Operations.update_operation(operation, @update_attrs)

      assert operation.description == "some updated description"
      assert operation.type == "some updated type"
      assert operation.value == Decimal.new("456.7")
    end

    test "update_operation/2 with invalid data returns error changeset" do
      operation = operation_fixture()
      assert {:error, %Ecto.Changeset{}} = Operations.update_operation(operation, @invalid_attrs)
      assert operation == Operations.get_operation!(operation.id)
    end

    test "delete_operation/1 deletes the operation" do
      operation = operation_fixture()
      assert {:ok, %Operation{}} = Operations.delete_operation(operation)
      assert_raise Ecto.NoResultsError, fn -> Operations.get_operation!(operation.id) end
    end

    test "change_operation/1 returns a operation changeset" do
      operation = operation_fixture()
      assert %Ecto.Changeset{} = Operations.change_operation(operation)
    end
  end
end
