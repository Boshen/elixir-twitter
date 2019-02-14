defmodule Twitter.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Twitter.Repo

  alias Twitter.Accounts.User
  alias Twitter.Accounts.Follower

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Returns `nil` if the User does not exist.

  ## Examples

      iex> get_user(123)
      {:ok, %User{}}

      iex> get_user(456)
      {:error, nil}

  """
  def get_user(id) do
    case Repo.get(User, id) do
      nil -> {:error, nil}
      user -> {:ok, user}
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update(stale_error_field: true)
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user, stale_error_field: true)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def authenticate_user(name, _plain_text_password) do
    query = from u in User, where: u.name == ^name

    case Repo.one(query) do
      nil ->
        {:error, :invalid_credentials}

      user ->
        {:ok, user}
    end
  end

  @doc """
    Follow a user
  """
  def follow_user(%User{} = user, follower_id) do
    %Follower{}
    |> Follower.changeset(%{
      user_id: user.id,
      follower_id: follower_id
    })
    |> Repo.insert()
  end

  @doc """
    Unfollow a user
  """
  def unfollow_user(%User{} = user, follower_id) do
    query =
      from f in Follower,
        where: f.user_id == ^user.id and f.follower_id == ^follower_id

    Repo.delete_all(query)
  end

  @doc """
    Returns all the followers for a given user
  """
  def followers(%User{} = user) do
    query =
      from f in Follower,
        where: f.user_id == ^user.id,
        inner_join: u in User,
        on: u.id == f.follower_id,
        select: u

    Repo.all(query)
  end
end
