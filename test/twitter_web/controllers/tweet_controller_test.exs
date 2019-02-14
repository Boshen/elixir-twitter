defmodule TwitterWeb.TweetControllerTest do
  use TwitterWeb.ConnCase
  alias Twitter.Accounts
  alias Twitter.Resources

  def create_tweet(params) do
    {:ok, user} = Accounts.create_user(%{name: "username"})
    {:ok, tweet} = Resources.create_tweet(Map.merge(params, %{creator_id: user.id}))
    {tweet, user}
  end

  test "POST /api/tweet", %{conn: conn} do
    {:ok, user} = Accounts.create_user(%{name: "username"})
    tweet = %{message: "Message 1", creator_id: user.id}

    response =
      conn
      |> post(Routes.tweet_path(conn, :create), tweet)
      |> json_response(201)

    assert response["message"] == tweet.message
    assert response["creator"]["name"] == user.name
  end

  test "GET /api/tweet/:id", %{conn: conn} do
    {tweet, user} = create_tweet(%{message: "Message 1"})

    response =
      conn
      |> get(Routes.tweet_path(conn, :show, tweet.id))
      |> json_response(200)

    assert response["message"] == tweet.message
    assert response["creator"]["name"] == user.name
  end

  test "GET /api/tweet/:id with 404", %{conn: conn} do
    response =
      conn
      |> get(Routes.tweet_path(conn, :show, 0))
      |> json_response(404)

    assert response
  end

  test "GET /api/tweet", %{conn: conn} do
    {:ok, user1} = Accounts.create_user(%{name: "username 1"})
    {:ok, user2} = Accounts.create_user(%{name: "username 2"})
    {:ok, tweet1} = Resources.create_tweet(%{message: "Message 1", creator_id: user1.id})
    {:ok, tweet2} = Resources.create_tweet(%{message: "Message 1", creator_id: user2.id})

    response =
      conn
      |> get(Routes.tweet_path(conn, :index))
      |> json_response(200)

    assert Enum.count(response) > 0

    expected = [
      %{"message" => tweet1.message},
      %{"message" => tweet2.message}
    ]

    assert Enum.map(response, &Map.take(&1, ["message"])) == expected
  end

  test "PUT /api/tweet/:id", %{conn: conn} do
    {tweet, _user} = create_tweet(%{message: "Message 1"})

    put_data = %{message: "Message 2"}

    response =
      conn
      |> put(Routes.tweet_path(conn, :update, tweet.id, put_data))
      |> json_response(200)

    assert response["message"] == put_data[:message]
  end

  test "PUT /api/tweet/:id 400", %{conn: conn} do
    put_data = %{message: "Message 2"}

    response =
      conn
      |> put(Routes.tweet_path(conn, :update, 0, put_data))
      |> json_response(400)

    assert response
  end

  test "DELETE /api/tweet/:id", %{conn: conn} do
    {tweet, _user} = create_tweet(%{message: "Message 1"})

    response =
      conn
      |> delete(Routes.tweet_path(conn, :delete, tweet.id))
      |> json_response(200)

    assert response
  end

  test "DELETE /api/tweet/:id 400", %{conn: conn} do
    response =
      conn
      |> delete(Routes.tweet_path(conn, :delete, 0))
      |> json_response(400)

    assert response
  end
end
