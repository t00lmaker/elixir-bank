defmodule BankWeb.ClientControllerTest do
  use BankWeb.ConnCase

  import Ecto.Query, only: [from: 2]
  import Bank.AuthTestHelper, only: [api_token: 0]

  alias Bank.Accounts.Account
  alias Bank.Clients
  alias Bank.Clients.Client
  alias Bank.Repo

  @create_attrs %{
    birth_date: "some birth_date",
    name: "some name",
    social_id: "some social_id",
    email: "my@mail.com"
  }
  @update_attrs %{
    birth_date: "some updated birth_date",
    name: "some updated name",
    social_id: "some updated social_id",
    email: "other@mail.com"
  }
  @invalid_attrs %{birth_date: nil, name: nil, social_id: nil, email: nil}

  def fixture(:client) do
    {:ok, client} = Clients.create_client(@create_attrs)
    client
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
    test "lists all clients", %{conn: conn} do
      conn = get(conn, Routes.client_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create client" do
    test "renders client when data is valid", %{conn: conn} do
      conn = post(conn, Routes.client_path(conn, :create), client: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.client_path(conn, :show, id))

      assert %{
               "id" => id,
               "birth_date" => "some birth_date",
               "name" => "some name",
               "social_id" => "some social_id",
               "is_active" => true,
               "email" => "my@mail.com"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.client_path(conn, :create), client: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "a new account to new client", %{conn: conn} do
      conn = post(conn, Routes.client_path(conn, :create), client: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      query = from a in Account, where: [client_id: ^id]
      assert Repo.exists?(query)
    end

    test "a new account with initial balance of 1000 to new client", %{conn: conn} do
      conn = post(conn, Routes.client_path(conn, :create), client: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      query = from a in Account, where: [client_id: ^id]
      account = Repo.one(query)
      assert account.balance == Decimal.new("1000")
    end

    test " should be protected", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "bearer ")
        |> get(Routes.account_path(conn, :create), client: @create_attrs)

      assert response(conn, 401)
    end
  end

  describe "update client" do
    setup [:create_client]

    test "renders client when data is valid", %{conn: conn, client: %Client{id: id} = client} do
      conn = put(conn, Routes.client_path(conn, :update, client), client: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.client_path(conn, :show, id))

      assert %{
               "id" => id,
               "birth_date" => "some updated birth_date",
               "name" => "some updated name",
               "social_id" => "some updated social_id",
               "is_active" => true,
               "email" => "other@mail.com"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, client: client} do
      conn = put(conn, Routes.client_path(conn, :update, client), client: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "should be protected", %{conn: conn, client: client} do
      conn =
        conn
        |> put_req_header("authorization", "bearer ")
        |> get(Routes.account_path(conn, :update, client), client: @update_attrs)

      assert response(conn, 401)
    end
  end

  describe "delete client inactive client" do
    setup [:create_client]

    test "deletes chosen client", %{conn: conn, client: client} do
      conn = delete(conn, Routes.client_path(conn, :delete, client))
      assert response(conn, 204)

      conn = get(conn, Routes.client_path(conn, :show, client))

      assert %{
               "id" => id,
               "birth_date" => "some birth_date",
               "name" => "some name",
               "social_id" => "some social_id",
               "is_active" => false,
               "email" => "my@mail.com"
             } = json_response(conn, 200)["data"]
    end

    test "should be protected", %{conn: conn, client: client} do
      conn =
        conn
        |> put_req_header("authorization", "bearer ")
        |> get(Routes.account_path(conn, :delete, client))

      assert response(conn, 401)
    end
  end

  defp create_client(_) do
    client = fixture(:client)
    {:ok, client: client}
  end
end
