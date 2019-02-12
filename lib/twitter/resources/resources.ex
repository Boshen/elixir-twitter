defmodule Twitter.Resources do
  @moduledoc """
  The Resources context.
  """

  import Ecto.Query, warn: false
  alias Twitter.Repo

  alias Twitter.Resources.Tweet
  alias Twitter.Accounts.User

  @doc """
  Returns the list of tweets.

  ## Examples

      iex> list_tweets()
      [%Tweet{}, ...]

  """
  def list_tweets do
    query =
      from t in Tweet,
        inner_join: u in User,
        on: u.id == t.creator_id,
        select_merge: %{creator: u}

    Repo.all(query)
  end

  @doc """
  Gets a single tweet.

  Returns `nil` if the Tweet does not exist.

  ## Examples

      iex> get_tweet(123)
      {:ok, %Tweet{}}

      iex> get_tweet(456)
      {:error, %Ecto.Changeset{}}

  """
  def get_tweet(id) do
    query =
      from t in Tweet,
        where: t.id == ^id,
        inner_join: u in User,
        on: u.id == t.creator_id,
        select_merge: %{creator: u}

    case Repo.all(query) do
      [tweet] -> {:ok, tweet}
      [] -> {:error, nil}
    end
  end

  @doc """
  Creates a tweet.

  ## Examples

      iex> create_tweet(%{field: value})
      {:ok, %Tweet{}}

      iex> create_tweet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tweet(attrs \\ %{}) do
    %Tweet{}
    |> Tweet.check_insert(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tweet.

  ## Examples

      iex> update_tweet(tweet, %{field: new_value})
      {:ok, %Tweet{}}

      iex> update_tweet(tweet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tweet(%Tweet{} = tweet, attrs) do
    tweet
    |> Tweet.changeset(attrs)
    |> Repo.update(stale_error_field: true)
  end

  @doc """
  Deletes a Tweet.

  ## Examples

      iex> delete_tweet(tweet)
      {:ok, %Tweet{}}

      iex> delete_tweet(tweet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tweet(%Tweet{} = tweet) do
    Repo.delete(tweet, stale_error_field: true)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tweet changes.

  ## Examples

      iex> change_tweet(tweet)
      %Ecto.Changeset{source: %Tweet{}}

  """
  def change_tweet(%Tweet{} = tweet) do
    Tweet.changeset(tweet, %{})
  end
end
