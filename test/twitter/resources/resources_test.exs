defmodule Twitter.ResourcesTest do
  use Twitter.DataCase

  alias Twitter.Accounts
  alias Twitter.Resources
  alias Twitter.Resources.Tweet

  describe "tweets" do
    @update_attrs %{message: "some updated message"}
    @invalid_attrs %{message: nil}

    def tweet_fixture(message \\ "message", username \\ "username") do
      {:ok, user} = Accounts.create_user(%{name: username})

      {:ok, tweet} = Resources.create_tweet(%{message: message, creator_id: user.id})

      Map.merge(tweet, %{creator: user})
    end

    test "list_user_tweets/1 returns all tweets for a given user" do
      tweet1 = tweet_fixture("message 1", "user 1")
      tweet_fixture("message 2", "user 2")
      tweet_fixture("message 3", "user 3")
      assert Resources.list_user_tweets(tweet1.creator) == [tweet1]
    end

    test "count_user_tweets/1 returns count" do
      tweet1 = tweet_fixture("message 1", "user 1")
      tweet_fixture("message 2", "user 2")
      tweet_fixture("message 3", "user 3")
      assert Resources.count_user_tweets(tweet1.creator) == 1
    end

    test "list_following_tweets/1 returns all tweets that the user follow" do
      tweet1 = tweet_fixture("message 1", "user 1")
      tweet2 = tweet_fixture("message 2", "user 2")
      {:ok, _result} = Accounts.follow_user(tweet1.creator, tweet2.creator.id)
      result = Resources.list_following_tweets(tweet1.creator)

      assert result == %{
               entries: [tweet2],
               after: nil,
               before: nil,
               limit: 20,
               total_count: nil,
               total_count_cap_exceeded: nil
             }
    end

    test "get_tweet/1 returns the tweet with given id" do
      tweet = tweet_fixture()
      {:ok, t} = Resources.get_tweet(tweet.id)
      assert t == tweet
    end

    test "create_tweet/1 with valid data creates a tweet" do
      {:ok, user} = Accounts.create_user(%{name: "username"})

      assert {:ok, %Tweet{} = tweet} =
               Resources.create_tweet(%{message: "message", creator_id: user.id})

      assert tweet.message == "message"
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
      {:ok, t} = Resources.get_tweet(tweet.id)
      assert t == tweet
    end

    test "delete_tweet/1 deletes the tweet" do
      tweet = tweet_fixture()
      assert {:ok, %Tweet{}} = Resources.delete_tweet(tweet)
      assert {:error, _c} = Resources.get_tweet(tweet.id)
    end

    test "change_tweet/1 returns a tweet changeset" do
      tweet = tweet_fixture()
      assert %Ecto.Changeset{} = Resources.change_tweet(tweet)
    end
  end
end
