defmodule TwitterWeb.PageControllerTest do
  use TwitterWeb.ConnCase

  test "GET /", %{conn: conn} do
    assert conn |> get("/") |> html_response(200)
  end
end
