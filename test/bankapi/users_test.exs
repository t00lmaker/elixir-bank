defmodule Bank.UsersTest do
  use Bank.DataCase

  alias Bank.Users

  import Bank.AuthTestHelper, only: [create_user: 0]

  describe "users" do
    alias Bank.Users.User

    @valid_attrs %{
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

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      all_users = Users.list_users()
      [first_user | _] = all_users
      assert length(all_users) == 1
      assert first_user.id == user.id
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      user_get = Users.get_user!(user.id)
      assert user_get.id == user.id
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Users.create_user(@valid_attrs)
      assert user.password_hash
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user_update} = Users.update_user(user, @update_attrs)
      refute user.password_hash == user_update.password_hash
      assert user_update.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      user_after = Users.get_user!(user.id)
      assert user.username == user.username
      assert user.password_hash == user_after.password_hash
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end

    test "authetic return token when username and password are valids" do
      user = create_user()
      assert {:ok, _} = Users.authentic(user.username, user.password)
    end

    test "authentic return unauthorized when username not found" do
      user = create_user()
      assert {:error, :unauthorized} == Users.authentic(user.username <> "some", user.password)
    end

    test "authentic return unauthorized when password diferent from user" do
      user = create_user()
      assert {:error, :unauthorized} == Users.authentic(user.username, user.password <> "some")
    end
  end
end
