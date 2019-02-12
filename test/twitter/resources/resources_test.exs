defmodule Twitter.ResourcesTest do
  use Twitter.DataCase

  alias Twitter.Resources

  describe "tweets" do
    alias Twitter.Resources.Tweet

    @valid_attrs %{message: "some message"}
    @update_attrs %{message: "some updated message"}
    @invalid_attrs %{message: nil}

    def tweet_fixture(attrs \\ %{}) do
      {:ok, tweet} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Resources.create_tweet()

      tweet
    end

    test "list_tweets/0 returns all tweets" do
      tweet = tweet_fixture()
      assert Resources.list_tweets() == [tweet]
    end

    test "get_tweet!/1 returns the tweet with given id" do
      tweet = tweet_fixture()
      assert Resources.get_tweet!(tweet.id) == tweet
    end

    test "create_tweet/1 with valid data creates a tweet" do
      assert {:ok, %Tweet{} = tweet} = Resources.create_tweet(@valid_attrs)
      assert tweet.message == "some message"
    end

    test "create_tweet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Resources.create_tweet(@invalid_attrs)
    end

    test "update_tweet/2 with valid data updates the tweet" do
      tweet = tweet_fixture()
      assert {:ok, %Tweet{} = tweet} = Resources.update_tweet(tweet, @update_attrs)
      assert tweet.message == "some updated message"
    end

    test "update_tweet/2 with invalid data returns error changeset" do
      tweet = tweet_fixture()
      assert {:error, %Ecto.Changeset{}} = Resources.update_tweet(tweet, @invalid_attrs)
      assert tweet == Resources.get_tweet!(tweet.id)
    end

    test "delete_tweet/1 deletes the tweet" do
      tweet = tweet_fixture()
      assert {:ok, %Tweet{}} = Resources.delete_tweet(tweet)
      assert_raise Ecto.NoResultsError, fn -> Resources.get_tweet!(tweet.id) end
    end

    test "change_tweet/1 returns a tweet changeset" do
      tweet = tweet_fixture()
      assert %Ecto.Changeset{} = Resources.change_tweet(tweet)
    end
  end
end
