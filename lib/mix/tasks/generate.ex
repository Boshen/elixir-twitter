defmodule Mix.Tasks.Twitter.Generate do
  use Mix.Task

  @moduledoc "Generates fake data for testing"

  alias Twitter.Accounts.Follower
  alias Twitter.Accounts.User
  alias Twitter.Repo
  alias Twitter.Resources.Tweet

  @followers_count 100
  @tweets_count 10_000

  @impl Mix.Task
  def run(_) do
    Mix.Task.run("app.start")
    Faker.start()
    generate()
  end

  defp generate do
    me = Repo.get_by(User, name: "Superuser")

    utc_datetime_usec = fn ->
      DateTime.from_unix!(System.system_time(:microsecond), :microsecond)
    end

    # create users
    followers =
      for _i <- 1..@followers_count,
          do: %{
            name: Faker.Name.name(),
            inserted_at: utc_datetime_usec.(),
            updated_at: utc_datetime_usec.()
          }

    {_count, followers} =
      Repo.insert_all(User, followers, returning: [:id], on_conflict: :nothing)

    # follow users
    followings =
      for f <- followers,
          do: %{
            user_id: me.id,
            follower_id: f.id,
            inserted_at: utc_datetime_usec.(),
            updated_at: utc_datetime_usec.()
          }

    Repo.insert_all(Follower, followings, returning: [:id])

    # each follower creates tweets
    Enum.each(followers, fn follower ->
      tweets =
        for _i <- 1..@tweets_count,
            do: %{
              message: Faker.Lorem.sentence(),
              creator_id: follower.id,
              inserted_at: utc_datetime_usec.(),
              updated_at: utc_datetime_usec.()
            }

      Repo.insert_all(Tweet, tweets)
    end)
  end
end
