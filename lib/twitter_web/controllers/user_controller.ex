defmodule TwitterWeb.UserController do
  use TwitterWeb, :controller
  alias Twitter.Accounts
  alias Twitter.Accounts.Guardian.Plug
  alias Twitter.Accounts.User
  alias Twitter.Resources

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

  def count(conn, _params) do
    current_user = Plug.current_resource(conn)
    tweets = Resources.count_user_tweets(current_user)

    conn
    |> json(%{
      tweets: tweets
    })
  end
end
