defmodule TwitterWeb.SessionControllerTest do
  use TwitterWeb.ConnCase
  alias TwitterWeb.Guardian.Plug

  test "POST /api/logout", %{conn: conn} do
    conn = post(conn, Routes.session_path(conn, :logout))

    user = Plug.current_resource(conn)

    assert user == nil
    assert json_response(conn, 200)
  end

  test "POST /api/login 200", %{conn: conn} do
    user = %{username: "Superuser"}

    conn =
      conn
      |> post(Routes.session_path(conn, :logout))
      |> post(Routes.session_path(conn, :login), user)

    user = Plug.current_resource(conn)

    assert user.name == "Superuser"
    assert json_response(conn, 200)
  end

  test "POST /api/login 400", %{conn: conn} do
    user = %{username: "Bad User"}

    response =
      conn
      |> post(Routes.session_path(conn, :logout))
      |> post(Routes.session_path(conn, :login), user)
      |> json_response(400)

    assert response
  end

  test "GET /api/user/me when logged in", %{conn: conn} do
    response =
      conn
      |> get(Routes.session_path(conn, :auth))
      |> json_response(200)

    assert response["name"] == "Superuser"
  end

  test "GET /api/user/me when logged out", %{conn: conn} do
    response =
      conn
      |> post(Routes.session_path(conn, :logout))
      |> get(Routes.session_path(conn, :auth))
      |> json_response(401)

    assert response
  end
end
