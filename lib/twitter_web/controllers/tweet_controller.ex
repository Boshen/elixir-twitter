defmodule TwitterWeb.TweetController do
  use TwitterWeb, :controller
  alias Twitter.Repo
  alias Twitter.Tweet

  def index(conn, _params) do
    tweets = Repo.all(Twitter.Tweet)
    json(conn, tweets)
  end

  def edit(_conn, _params) do
  end

  def new(_conn, _params) do
  end

  def show(_conn, _params) do
  end

  def create(conn, params) do
    changeset = Tweet.changeset(%Tweet{}, params)

    case Repo.insert(changeset) do
      {:ok, tweet} ->
        json(put_status(conn, :created), tweet)

      {:error, _changeset} ->
        json(put_status(conn, :bad_request), %{errors: ["unable to create tweet"]})
    end
  end

  def update(_conn, _params) do
  end

  def delete(_conn, _params) do
  end
end
