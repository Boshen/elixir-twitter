defmodule TwitterWeb.TweetControllerTest do
  use TwitterWeb.ConnCase
  alias Twitter.Accounts
  alias Twitter.Accounts.Guardian.Plug

  def create_tweet(conn) do
    tweet = %{message: "message"}

    conn
    |> post(Routes.tweet_path(conn, :create), tweet)
    |> json_response(201)
  end

  test "POST /api/tweet", %{conn: conn} do
    user = Plug.current_resource(conn)
    tweet = %{message: "Message 1"}

    response =
      conn
      |> post(Routes.tweet_path(conn, :create), tweet)
      |> json_response(201)

    assert response["message"] == tweet.message
    assert response["creator"]["name"] == user.name
  end

  test "GET /api/tweet/:id", %{conn: conn} do
    tweet = create_tweet(conn)

    response =
      conn
      |> get(Routes.tweet_path(conn, :show, tweet["id"]))
      |> json_response(200)

    assert response == tweet
  end

  test "GET /api/tweet/:id with 404", %{conn: conn} do
    response =
      conn
      |> get(Routes.tweet_path(conn, :show, 0))
      |> json_response(404)

    assert response
  end

  test "GET /api/tweet", %{conn: conn} do
    {:ok, new_user} = Accounts.create_user(%{name: "new user"})

    follower_tweet =
      conn
      |> Plug.sign_in(new_user)
      |> post(Routes.tweet_path(conn, :create), %{message: "message 2"})
      |> json_response(201)

    conn
    |> post(Routes.follower_path(conn, :create), %{follower_id: follower_tweet["creator"]["id"]})
    |> json_response(201)

    result =
      conn
      |> get(Routes.tweet_path(conn, :index))
      |> json_response(200)

    assert result == %{
             "entries" => [follower_tweet],
             "after" => nil,
             "before" => nil,
             "limit" => 20,
             "total_count" => 1,
             "total_count_cap_exceeded" => false
           }
  end

  test "PUT /api/tweet/:id", %{conn: conn} do
    tweet = create_tweet(conn)

    put_data = %{message: "Message 2"}

    response =
      conn
      |> put(Routes.tweet_path(conn, :update, tweet["id"], put_data))
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
    tweet = create_tweet(conn)

    response =
      conn
      |> delete(Routes.tweet_path(conn, :delete, tweet["id"]))
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
