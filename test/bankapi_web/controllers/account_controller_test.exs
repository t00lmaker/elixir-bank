defmodule BankWeb.AccountControllerTest do
  use BankWeb.ConnCase

  alias Bank.Accounts
  alias Bank.Accounts.Account
  alias Bank.Clients

  import Bank.AuthTestHelper, only: [api_token: 0]

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

  @create_client_attrs %{
    birth_date: "some birth_date",
    name: "some name",
    social_id: "some social_id",
    email: "my@mail.com"
  }

  def fixture(:client) do
    {:ok, client} = Clients.create_client(@create_client_attrs)
    client
  end

  def fixture(:account) do
    client = fixture(:client)
    {:ok, account} = Accounts.create_account(@create_attrs, client.id)
    account
  end

  setup %{conn: conn} do
    {:ok, jwt, _} = api_token()

    {:ok,
     conn:
       conn
       |> put_req_header("accept", "application/json")
       |> put_req_header("authorization", "bearer " <> jwt)}
  end

  describe "index" do
    test "lists all accounts", %{conn: conn} do
      conn = get(conn, Routes.account_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end

    test "show all should be protected", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "bearer ")
        |> get(Routes.account_path(conn, :index))

      assert response(conn, 401)
    end
  end

  describe "create account" do
    test "renders account when data is valid", %{conn: conn} do
      client = fixture(:client)

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

    test "the attribute client_id should be required", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create), account: @create_attrs)
      assert "client_id é obrigatorio" = json_response(conn, 422)["msg"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      client = fixture(:client)

      conn =
        post(conn, Routes.account_path(conn, :create),
          account: @invalid_attrs,
          client_id: client.id
        )

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "should be protected", %{conn: conn} do
      client = fixture(:client)

      conn =
        conn
        |> put_req_header("authorization", "bearer ")
        |> post(Routes.account_path(conn, :create),
          account: @create_attrs,
          client_id: client.id
        )

      assert response(conn, 401)
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

    test "update should be protected", %{conn: conn, account: account} do
      conn =
        conn
        |> put_req_header("authorization", "bearer ")
        |> put(Routes.account_path(conn, :update, account), account: @update_attrs)

      assert response(conn, 401)
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

    test "delete should be proteced", %{conn: conn, account: account} do
      conn =
        conn
        |> put_req_header("authorization", "bearer ")
        |> delete(Routes.account_path(conn, :delete, account))

      assert response(conn, 401)
    end
  end

  defp create_account(_) do
    account = fixture(:account)
    {:ok, account: account}
  end
end
