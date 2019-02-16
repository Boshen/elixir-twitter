defmodule Twitter.Resources do
  @moduledoc """
  The Resources context.
  """

  import Ecto.Query, warn: false
  alias Twitter.Accounts.Follower
  alias Twitter.Accounts.User
  alias Twitter.Repo
  alias Twitter.Resources.Tweet

  def list_user_tweets(%User{} = user) do
    user
    |> user_tweets_query()
    |> add_creator_to_query()
    |> Repo.all()
  end

  def count_user_tweets(%User{} = user) do
    user
    |> user_tweets_query()
    |> Repo.aggregate(:count, :id)
  end

  defp user_tweets_query(%User{} = user) do
    from t in Tweet,
      order_by: [asc: :inserted_at],
      where: t.creator_id == ^user.id
  end

  defp add_creator_to_query(query) do
    from t in query,
      join: u in User,
      on: u.id == t.creator_id,
      select_merge: %{creator: u}
  end

  def list_following_tweets(%User{} = user, cursor_after \\ nil) do
    query =
      from t in Tweet,
        inner_join: f in Follower,
        on: f.user_id == ^user.id,
        order_by: [asc: t.inserted_at, asc: t.id],
        where: f.follower_id == t.creator_id

    paginator =
      query
      |> add_creator_to_query()
      |> Repo.paginate_cursor(
        include_total_count: true,
        after: cursor_after,
        cursor_fields: [:inserted_at, :id],
        limit: 5
      )

    Map.merge(%{entries: paginator.entries}, Map.from_struct(paginator.metadata))
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
