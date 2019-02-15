defmodule TwitterWeb.UserController do
  use TwitterWeb, :controller
  alias Twitter.Accounts
  alias Twitter.Accounts.Guardian.Plug
  alias Twitter.Accounts.User

  action_fallback TwitterWeb.FallbackController

  def index(conn, _params) do
    conn |> json(Accounts.list_users())
  end

  def show(conn, params) do
    with {:ok, user} <- Accounts.get_user(params["id"]) do
      conn |> json(user)
    end
  end

  def create(conn, params) do
    with {:ok, user} <- Accounts.create_user(params) do
      conn
      |> put_status(:created)
      |> json(user)
    end
  end

  def update(conn, params) do
    {id, data} = Map.pop(params, "id")

    user = %User{id: String.to_integer(id)}

    with {:ok, user} <- Accounts.update_user(user, data) do
      conn |> json(user)
    end
  end

  def delete(conn, params) do
    user = %User{id: String.to_integer(params["id"])}

    with {:ok, user} <- Accounts.delete_user(user) do
      conn
      |> json(user)
    end
  end

  def follow(conn, %{"follower_id" => follower_id}) do
    current_user = Plug.current_resource(conn)

    with {:ok, follower} = Accounts.follow_user(current_user, follower_id) do
      conn
      |> json(follower)
    end
  end
end