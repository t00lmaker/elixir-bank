defmodule BankWeb.UserControllerTest do
  use BankWeb.ConnCase

  alias Bank.Users
  alias Bank.Users.User

  import Bank.AuthTestHelper, only: [api_token: 0]

  @create_attrs %{
    password: "some password",
    password_confirmation: "some password",
    username: "some username"
  }
  @update_attrs %{
    password: "some updated password",
    password_confirmation: "some updated password",
    username: "some updated username"
  }
  @invalid_attrs %{password: nil, password_confirmation: nil, username: nil}

  def fixture(:user) do
    {:ok, user} = Users.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, jwt, _} = api_token()

    {:ok,
     conn:
       conn
       |> put_req_header("accept", "application/json")
       |> put_req_header("authorization", "bearer " <> jwt)}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "username" => "some username"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "should be protected", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "bearer ")
        |> get(Routes.account_path(conn, :create), user: @create_attrs)

      assert response(conn, 401)
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "username" => "some updated username"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "should be protected", %{conn: conn, user: user} do
      conn =
        conn
        |> put_req_header("authorization", "bearer ")
        |> get(Routes.account_path(conn, :update, user), user: @update_attrs)

      assert response(conn, 401)
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end

    test "should be protected", %{conn: conn, user: user} do
      conn =
        conn
        |> put_req_header("authorization", "bearer ")
        |> get(Routes.account_path(conn, :update, user))

      assert response(conn, 401)
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
