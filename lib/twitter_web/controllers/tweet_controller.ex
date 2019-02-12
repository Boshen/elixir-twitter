defmodule TwitterWeb.TweetController do
  use TwitterWeb, :controller
  alias Twitter.Resources
  alias Twitter.Resources.Tweet

  def index(conn, _params) do
    conn |> json(Resources.list_tweets())
  end

  def show(conn, params) do
    try do
      tweet = Resources.get_tweet!(params["id"])
      conn |> json(tweet)
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: ["not found"]})
    end
  end

  def create(conn, params) do
    case Resources.create_tweet(params) do
      {:ok, tweet} ->
        conn
        |> put_status(:created)
        |> json(tweet)

      {:error, _changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: ["unable to create tweet"]})
    end
  end

  def update(conn, params) do
    try do
      {id, data} = Map.pop(params, "id")
      result = Resources.update_tweet(%Tweet{id: String.to_integer(id)}, data)

      case result do
        {:ok, tweet} ->
          conn |> json(tweet)

        {:error, changeset} ->
          conn
          |> put_status(:bad_request)
          |> json(changeset)
      end
    rescue
      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: ["unable to update tweet"]})
    end
  end

  def delete(conn, params) do
    try do
      result = Resources.delete_tweet(%Tweet{id: String.to_integer(params["id"])})

      case result do
        {:ok, tweet} ->
          conn
          |> json(tweet)

        {:error, changeset} ->
          conn
          |> put_status(:bad_request)
          |> json(changeset)
      end
    rescue
      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: ["unable to delete tweet"]})
    end
  end
end
