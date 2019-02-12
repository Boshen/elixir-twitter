defmodule TwitterWeb.TweetControllerTest do
  use TwitterWeb.ConnCase
  alias Twitter.Resources

  test "POST /api/tweet", %{conn: conn} do
    post_data = %{message: "Message 1"}

    response =
      conn
      |> post(Routes.tweet_path(conn, :create), post_data)
      |> json_response(201)

    assert response["message"] == post_data[:message]
  end

  test "GET /api/tweet/:id", %{conn: conn} do
    post_data = %{message: "Message 1"}

    {:ok, tweet} = Resources.create_tweet(post_data)

    response =
      conn
      |> get(Routes.tweet_path(conn, :show, tweet.id))
      |> json_response(200)

    assert response["message"] == post_data[:message]
  end

  test "GET /api/tweet/:id with 404", %{conn: conn} do
    response =
      conn
      |> get(Routes.tweet_path(conn, :show, 0))
      |> json_response(404)

    assert response
  end

  test "GET /api/tweet", %{conn: conn} do
    tweets = [
      %{message: "Message 1"},
      %{message: "Message 2"}
    ]

    [
      {:ok, user1},
      {:ok, user2}
    ] = Enum.map(tweets, &Resources.create_tweet(&1))

    response =
      conn
      |> get(Routes.tweet_path(conn, :index))
      |> json_response(200)

    assert Enum.count(response) > 0

    expected = [
      %{"message" => user1.message},
      %{"message" => user2.message}
    ]

    assert Enum.map(response, &Map.take(&1, ["message"])) == expected
  end

  test "PUT /api/tweet/:id", %{conn: conn} do
    {:ok, tweet} = Resources.create_tweet(%{message: "Message 1"})

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
    {:ok, tweet} = Resources.create_tweet(%{message: "Message 1"})

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
