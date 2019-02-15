defmodule TwitterWeb.UserControllerTest do
  use TwitterWeb.ConnCase
  alias Twitter.Accounts

  test "POST /api/user", %{conn: conn} do
    user = %{name: "Username 1"}

    response =
      conn
      |> post(Routes.user_path(conn, :create), user)
      |> json_response(201)

    assert response["name"] == user.name
  end

  test "GET /api/user/:id", %{conn: conn} do
    {:ok, user} = Accounts.create_user(%{name: "Username 1"})

    response =
      conn
      |> get(Routes.user_path(conn, :show, user.id))
      |> json_response(200)

    assert response["name"] == user.name
  end

  test "GET /api/user/:id with 404", %{conn: conn} do
    response =
      conn
      |> get(Routes.user_path(conn, :show, 0))
      |> json_response(404)

    assert response
  end

  test "GET /api/user", %{conn: conn} do
    current_user = conn |> get(Routes.user_path(conn, :show, 1)) |> json_response(200)

    user1 =
      conn
      |> post(Routes.user_path(conn, :create), %{name: "Username 1"})
      |> json_response(201)

    user2 =
      conn
      |> post(Routes.user_path(conn, :create), %{name: "Username 2"})
      |> json_response(201)

    response =
      conn
      |> get(Routes.user_path(conn, :index))
      |> json_response(200)

    expected = %{
      "entries" => [current_user, user1, user2],
      "page_number" => 1,
      "page_size" => 20,
      "total_entries" => 3,
      "total_pages" => 1
    }

    assert response == expected
  end

  test "PUT /api/user/:id", %{conn: conn} do
    {:ok, user} = Accounts.create_user(%{name: "Username 1"})

    put_data = %{name: "Username 2"}

    response =
      conn
      |> put(Routes.user_path(conn, :update, user.id, put_data))
      |> json_response(200)

    assert response["name"] == put_data[:name]
  end

  test "PUT /api/user/:id 400", %{conn: conn} do
    put_data = %{name: "Username 2"}

    response =
      conn
      |> put(Routes.user_path(conn, :update, 0, put_data))
      |> json_response(400)

    assert response
  end

  test "DELETE /api/user/:id", %{conn: conn} do
    {:ok, user} = Accounts.create_user(%{name: "Username 1"})

    response =
      conn
      |> delete(Routes.user_path(conn, :delete, user.id))
      |> json_response(200)

    assert response
  end

  test "DELETE /api/user/:id 400", %{conn: conn} do
    response =
      conn
      |> delete(Routes.user_path(conn, :delete, 0))
      |> json_response(400)

    assert response
  end

  test "GET /api/counts", %{conn: conn} do
    conn |> post(Routes.tweet_path(conn, :create), %{message: "message"})

    follower =
      conn |> post(Routes.user_path(conn, :create), %{name: "name"}) |> json_response(201)

    conn |> post(Routes.follower_path(conn, :create), %{follower_id: follower["id"]})

    response =
      conn
      |> get(Routes.user_path(conn, :count))
      |> json_response(200)

    expected = %{
      "tweets" => 1,
      "following" => 1,
      "followers" => 0
    }

    assert response == expected
  end
end
