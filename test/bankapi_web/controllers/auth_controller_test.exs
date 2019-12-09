defmodule BankWeb.AuthControllerTest do
  use BankWeb.ConnCase

  alias Bank.Guardian

  import Bank.AuthTestHelper, only: [create_user: 0]

  @valid_login %{
    username: "username",
    password: "password"
  }

  @invalid_login %{
    username: "username",
    password: "nopassword"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "login" do
    test "should be public", %{conn: conn} do
      create_user()
      conn = post(conn, Routes.auth_path(conn, :login), @valid_login)
      assert json_response(conn, 200)
    end

    test "should reponse with 401 status for invalid login", %{conn: conn} do
      create_user()
      conn = post(conn, Routes.auth_path(conn, :login), @invalid_login)
      assert json_response(conn, 401)
    end

    test "should response a jwt valid", %{conn: conn} do
      create_user()
      conn = post(conn, Routes.auth_path(conn, :login), @valid_login)
      jwt = json_response(conn, 200)["jwt"]
      assert {:ok, claims} = Guardian.decode_and_verify(jwt, %{})
    end

    test "should response a jwt with sub the user id", %{conn: conn} do
      user = create_user()
      conn = post(conn, Routes.auth_path(conn, :login), @valid_login)
      jwt = json_response(conn, 200)["jwt"]
      {:ok, claims} = Guardian.decode_and_verify(jwt, %{})
      assert claims["sub"] == user.id
    end
  end
end
