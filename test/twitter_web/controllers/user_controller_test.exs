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
    users = [
      %{name: "Username 1"},
      %{name: "Username 2"}
    ]

    [
      {:ok, user1},
      {:ok, user2}
    ] = Enum.map(users, &Accounts.create_user(&1))

    response =
      conn
      |> get(Routes.user_path(conn, :index))
      |> json_response(200)

    assert Enum.count(response) > 0

    expected = [
      %{"name" => "Superuser"},
      %{"name" => user1.name},
      %{"name" => user2.name}
    ]

    assert Enum.map(response, &Map.take(&1, ["name"])) == expected
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
end
