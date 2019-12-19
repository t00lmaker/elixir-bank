defmodule Bank.AccountsTest do
  use Bank.DataCase

  describe "account" do
    alias Bank.Accounts.Account
    alias Bank.Accounts
    alias Bank.Clients

    @valid_attrs %{
      balance: "120.5",
      identify: "some identify",
      type: "some type"
    }

    @update_attrs %{
      balance: "456.7",
      identify: "some updated identify",
      type: "some updated type"
    }

    @invalid_attrs %{balance: nil, identify: nil, type: nil}

    @client_attrs %{
      birth_date: "some birth_date",
      name: "some name",
      social_id: "some social_id",
      email: "my@mail.com"
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
        |> Enum.into(@valid_attrs)
        |> Accounts.create_account(client.id)

      account
    end

    test "list_account/0 returns all account" do
      account = account_fixture()
      assert Accounts.list_accounts() == [account]
    end

    test "get_account_by_client! retturn all accounts by client_id" do
      client = client_fixture()
      {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs, client.id)
      assert Accounts.get_account_by_client!(client.id) == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      client = client_fixture()
      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs, client.id)
      assert account.balance == Decimal.new("120.5")
      assert account.identify == "some identify"
      assert account.type == "some type"
    end

    test "create_account/1 with invalid data returns error changeset" do
      client = client_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs, client.id)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Accounts.update_account(account, @update_attrs)
      assert account.balance == Decimal.new("456.7")
      assert account.identify == "some updated identify"
      assert account.type == "some updated type"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end
end
