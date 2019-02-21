defmodule TwitterWeb.SessionController do
  use TwitterWeb, :controller

  alias Twitter.Accounts
  alias TwitterWeb.Guardian.Plug

  def login(conn, %{"username" => username}) do
    case Accounts.authenticate_user(username, "password") do
      {:ok, user} ->
        conn
        |> Plug.remember_me(user)
        |> Plug.sign_in(user)
        |> json(true)

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(reason)
    end
  end

  def logout(conn, _) do
    conn
    |> Plug.sign_out(clear_remember_me: true)
    |> json(true)
  end

  def auth(conn, _params) do
    user = Plug.current_resource(conn)
    conn |> json(user)
  end
end
