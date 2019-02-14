defmodule Twitter.AccountsTest do
  use Twitter.DataCase

  alias Twitter.Accounts

  describe "users" do
    alias Twitter.Accounts.User

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      superuser = Twitter.Repo.get_by(User, name: "Superuser")
      assert Accounts.list_users() == [superuser, user]
    end

    test "get_user/1 returns the user with given id" do
      user = user_fixture()
      {:ok, u} = Accounts.get_user(user.id)
      assert u == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "create_user/1 cannot create duplicate names" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@valid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      {:ok, u} = Accounts.get_user(user.id)
      assert user == u
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert {:error, nil} = Accounts.get_user(user.id)
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "follow_user/2 follows a user" do
      {:ok, user} = Accounts.create_user(%{name: "User 1"})
      {:ok, follower} = Accounts.create_user(%{name: "User 2"})
      {:ok, result} = Accounts.follow_user(user, follower.id)
      assert result.user_id == user.id
      assert result.follower_id == follower.id
    end

    test "follow_user/2 cannot follow a user twice" do
      {:ok, user} = Accounts.create_user(%{name: "User 1"})
      {:ok, follower} = Accounts.create_user(%{name: "User 2"})
      assert {:ok, _reason} = Accounts.follow_user(user, follower.id)
    end

    test "unfollow_user/2 unfollows a user" do
      {:ok, user} = Accounts.create_user(%{name: "User 1"})
      {:ok, follower} = Accounts.create_user(%{name: "User 2"})
      {:ok, _result} = Accounts.follow_user(user, follower.id)
      assert {1, nil} = Accounts.unfollow_user(user, follower.id)
    end

    test "follows/1 returns all followers for a given user" do
      {:ok, user} = Accounts.create_user(%{name: "User 1"})
      {:ok, follower} = Accounts.create_user(%{name: "User 2"})
      {:ok, _result} = Accounts.follow_user(user, follower.id)
      followers = Accounts.followers(user)
      assert followers == [follower]
    end
  end
end
