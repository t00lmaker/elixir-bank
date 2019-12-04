defmodule BankWeb.ClientControllerTest do
  use BankWeb.ConnCase

  import Ecto.Query, only: [from: 2]
  alias Bank.Accounts.Account
  alias Bank.Clients
  alias Bank.Clients.Client
  alias Bank.Repo

  @create_attrs %{
    birth_date: "some birth_date",
    name: "some name",
    social_id: "some social_id"
  }
  @update_attrs %{
    birth_date: "some updated birth_date",
    name: "some updated name",
    social_id: "some updated social_id"
  }
  @invalid_attrs %{birth_date: nil, name: nil, social_id: nil}

  def fixture(:client) do
    {:ok, client} = Clients.create_client(@create_attrs)
    client
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
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
               "is_active" => true
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
               "is_active" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, client: client} do
      conn = put(conn, Routes.client_path(conn, :update, client), client: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
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
               "is_active" => false
             } = json_response(conn, 200)["data"]
    end
  end

  defp create_client(_) do
    client = fixture(:client)
    {:ok, client: client}
  end
end
