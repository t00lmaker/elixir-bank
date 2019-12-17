defmodule BankWeb.OperationControllerTest do
  use BankWeb.ConnCase

  alias Bank.Repo
  alias Bank.Clients
  alias Bank.Accounts
  alias Bank.Operations
  alias Bank.Operations.Operation

  import Bank.AuthTestHelper, only: [api_token: 1]

  @client_attrs %{
    name: "Luan Pontes",
    social_id: "3",
    birth_date: "16/10/1991",
    email: "luanpontes2@gmail.com",
    user: %{
      username: "user",
      password: "password",
      password_confirmation: "password"
    }
  }

  @account_attrs %{
    identify: "17782-77",
    type: "A",
    balance: 1000
  }

  @create_attrs %{
    description: "some description",
    is_consolidaded: true,
    type: "CREDITO",
    value: "120.5"
  }
  @update_attrs %{
    description: "some updated description",
    is_consolidaded: false,
    type: "some updated type",
    value: "456.7"
  }
  @invalid_attrs %{description: nil, is_consolidaded: nil, type: nil, value: nil}

  def fixture(:operation, account) do
    {:ok, operation} = Operations.create_operation(@create_attrs, account.id)
    operation
  end

  def fixture(:account) do
    {:ok, client} = Clients.create_client(@client_attrs)
    {:ok, account} = Accounts.create_account(@account_attrs, client.id)
    Repo.preload(account, client: [:user])
  end

  setup %{conn: conn} do
    account = fixture(:account)
    {:ok, jwt, _} = api_token(account.client.user)

    conn =
      conn
      |> put_req_header("authorization", "bearer " <> jwt)
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn, account: account}
  end

  describe "index" do
    test "lists all opeations", %{conn: conn, account: account} do
      conn = get(conn, Routes.account_operation_path(conn, :index, account.id))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create operation" do
    test "renders operation when data is valid", %{conn: conn, account: account} do
      conn =
        post(conn, Routes.account_operation_path(conn, :create, account.id),
          operation: @create_attrs
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.account_operation_path(conn, :show, account.id, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "is_consolidaded" => true,
               "type" => "CREDITO",
               "value" => "120.5"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, account: account} do
      conn =
        post(conn, Routes.account_operation_path(conn, :create, account.id),
          operation: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update operation" do
    setup [:create_operation]

    test "renders operation when data is valid", %{
      conn: conn,
      account: account,
      operation: %Operation{id: id} = operation
    } do
      conn =
        put(conn, Routes.account_operation_path(conn, :update, account.id, operation),
          operation: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.account_operation_path(conn, :show, account.id, id))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "is_consolidaded" => false,
               "type" => "some updated type",
               "value" => "456.7"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      account: account,
      operation: operation
    } do
      conn =
        put(conn, Routes.account_operation_path(conn, :update, account.id, operation),
          operation: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete operation" do
    setup [:create_operation]

    test "deletes chosen operation", %{conn: conn, account: account, operation: operation} do
      conn = delete(conn, Routes.account_operation_path(conn, :delete, account.id, operation))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.account_operation_path(conn, :show, account.id, operation))
      end
    end
  end

  defp create_operation(%{account: account}) do
    operation = fixture(:operation, account)
    {:ok, operation: operation}
  end
end
