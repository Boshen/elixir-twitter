defmodule TwitterWeb.FollowerController do
  use TwitterWeb, :controller
  alias Twitter.Accounts
  alias Twitter.Accounts.Guardian.Plug

  action_fallback TwitterWeb.FallbackController

  def index(conn, _params) do
    current_user = Plug.current_resource(conn)
    followers = Accounts.followers(current_user)
    conn |> json(followers)
  end

  def create(conn, %{"follower_id" => follower_id}) do
    current_user = Plug.current_resource(conn)

    with {:ok, follower} <- Accounts.follow_user(current_user, follower_id) do
      conn
      |> put_status(:created)
      |> json(follower)
    end
  end

  def delete(conn, %{"id" => follower_id}) do
    current_user = Plug.current_resource(conn)
    Accounts.unfollow_user(current_user, follower_id)

    conn
    |> json(true)
  end
end
