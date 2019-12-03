defmodule BankWeb.AccountControllerTest do
  use BankWeb.ConnCase

  alias Bank.Accounts
  alias Bank.Accounts.Account
  alias Bank.ClientsTest

  @create_attrs %{
    balance: "120.5",
    identify: "some identify",
    is_active: true,
    type: "some type"
  }
  @update_attrs %{
    balance: "456.7",
    identify: "some updated identify",
    is_active: false,
    type: "some updated type"
  }
  @invalid_attrs %{balance: nil, identify: nil, is_active: nil, type: nil}

  def client_fixture() do
    ClientsTest.client_fixture(ClientsTest.client_valid_attrs())
  end

  def fixture(:account) do
    client = client_fixture()
    {:ok, account} = Accounts.create_account(@create_attrs, client.id)
    account
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all accounts", %{conn: conn} do
      conn = get(conn, Routes.account_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create account" do
    test "renders account when data is valid", %{conn: conn} do
      client = client_fixture()

      conn =
        post(conn, Routes.account_path(conn, :create),
          account: @create_attrs,
          client_id: client.id
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.account_path(conn, :show, id))

      assert %{
               "id" => id,
               "balance" => "120.5",
               "identify" => "some identify",
               "is_active" => true,
               "type" => "some type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      client = client_fixture()

      conn =
        post(conn, Routes.account_path(conn, :create),
          account: @invalid_attrs,
          client_id: client.id
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update account" do
    setup [:create_account]

    test "renders account when data is valid", %{conn: conn, account: %Account{id: id} = account} do
      conn = put(conn, Routes.account_path(conn, :update, account), account: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.account_path(conn, :show, id))

      assert %{
               "id" => id,
               "balance" => "456.7",
               "identify" => "some updated identify",
               "is_active" => false,
               "type" => "some updated type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, account: account} do
      conn = put(conn, Routes.account_path(conn, :update, account), account: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete account" do
    setup [:create_account]

    test "deletes chosen account", %{conn: conn, account: account} do
      conn = delete(conn, Routes.account_path(conn, :delete, account))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.account_path(conn, :show, account))
      end
    end
  end

  defp create_account(_) do
    account = fixture(:account)
    {:ok, account: account}
  end
end
