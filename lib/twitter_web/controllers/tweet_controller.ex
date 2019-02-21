defmodule TwitterWeb.TweetController do
  use TwitterWeb, :controller
  alias Twitter.Resources
  alias Twitter.Resources.Tweet
  alias TwitterWeb.Guardian.Plug

  action_fallback TwitterWeb.FallbackController

  def index(conn, params) do
    user = Plug.current_resource(conn)
    cursor_after = Map.get(params, "after", nil)
    tweets = Resources.list_following_tweets(user, cursor_after)
    conn |> json(tweets)
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
