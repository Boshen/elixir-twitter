defmodule TwitterWeb.TweetController do
  use TwitterWeb, :controller
  alias Twitter.Accounts.Guardian.Plug
  alias Twitter.Resources
  alias Twitter.Resources.Tweet

  action_fallback TwitterWeb.FallbackController

  def index(conn, _params) do
    conn |> json(Resources.list_tweets())
  end

  def show(conn, params) do
    with {:ok, tweet} <- Resources.get_tweet(params["id"]) do
      conn |> json(tweet)
    end
  end

  def create(conn, %{"message" => message}) do
    with user = Plug.current_resource(conn),
         {:ok, tweet} <-
           Resources.create_tweet(%{
             message: message,
             creator_id: user.id
           }),
         {:ok, tweet} = Resources.get_tweet(tweet.id) do
      conn
      |> put_status(:created)
      |> json(tweet)
    end
  end

  def update(conn, params) do
    {id, data} = Map.pop(params, "id")

    tweet = %Tweet{id: String.to_integer(id)}

    with {:ok, tweet} <- Resources.update_tweet(tweet, data) do
      conn |> json(tweet)
    end
  end

  def delete(conn, params) do
    tweet = %Tweet{id: String.to_integer(params["id"])}

    with {:ok, tweet} <- Resources.delete_tweet(tweet) do
      conn
      |> json(tweet)
    end
  end
end
