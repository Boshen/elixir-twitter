defmodule TwitterWeb.FollowerControllerTest do
  use TwitterWeb.ConnCase
  alias Twitter.Accounts
  alias Twitter.Accounts.Guardian.Plug

  test "POST /api/follow", %{conn: conn} do
    {:ok, follower} = Accounts.create_user(%{name: "Username 1"})

    payload = %{
      follower_id: follower.id
    }

    response =
      conn
      |> post(Routes.follower_path(conn, :create), payload)
      |> json_response(200)

    current_user = Plug.current_resource(conn)
    followers = Accounts.followers(current_user)

    assert Enum.count(followers) == 1
    assert response["user_id"] == current_user.id
    assert response["follower_id"] == follower.id
  end

  test "DELETE /api/follower", %{conn: conn} do
    {:ok, follower} = Accounts.create_user(%{name: "Username 1"})

    payload = %{
      follower_id: follower.id
    }

    post(conn, Routes.follower_path(conn, :create), payload)

    response =
      conn
      |> delete(Routes.follower_path(conn, :delete, follower.id))
      |> json_response(200)

    assert response
  end

  test "GET /api/follower", %{conn: conn} do
    {:ok, follower1} = Accounts.create_user(%{name: "Follower 1"})
    {:ok, follower2} = Accounts.create_user(%{name: "Follower 2"})

    post(conn, Routes.follower_path(conn, :create), %{follower_id: follower1.id})
    post(conn, Routes.follower_path(conn, :create), %{follower_id: follower2.id})

    response =
      conn
      |> get(Routes.follower_path(conn, :index))
      |> json_response(200)

    [f1, f2] = response
    assert f1["id"] == follower1.id
    assert f2["id"] == follower2.id
  end
end
