alias Twitter.Accounts.User
alias Twitter.Accounts.Follower
alias Twitter.Repo
alias Twitter.Resources.Tweet

Faker.start()

me = Repo.get_by(User, name: "Superuser")

followers_count = 100
tweets_count = 10000

utc_datetime_usec = fn ->
  DateTime.from_unix!(System.system_time(:microsecond), :microsecond)
end

# create users
followers =
  Enum.map(1..followers_count, fn _i ->
    %{
      name: Faker.Name.name(),
      inserted_at: utc_datetime_usec.(),
      updated_at: utc_datetime_usec.()
    }
  end)

{_count, followers} = Repo.insert_all(User, followers, returning: [:id])

# follow users
followings =
  Enum.map(followers, fn follower ->
    %{
      user_id: me.id,
      follower_id: follower.id,
      inserted_at: utc_datetime_usec.(),
      updated_at: utc_datetime_usec.()
    }
  end)

Repo.insert_all(Follower, followings, returning: [:id])

# each follower creates tweets
Enum.each(followers, fn follower ->
  tweets =
    Enum.map(1..tweets_count, fn _i ->
      %{
        message: Faker.Lorem.sentence(),
        creator_id: follower.id,
        inserted_at: utc_datetime_usec.(),
        updated_at: utc_datetime_usec.()
      }
    end)

  Repo.insert_all(Tweet, tweets)
end)
