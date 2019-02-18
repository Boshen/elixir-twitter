alias Twitter.Accounts
alias Twitter.Accounts.User
alias Twitter.Repo
alias Twitter.Resources

Faker.start()

me = Repo.get_by(User, name: "Superuser")

followers_count = 10
tweets_count = 1000

# create users
followers =
  Enum.map(0..10, fn _i ->
    Accounts.create_user(%{name: Faker.Name.name()})
    |> elem(1)
  end)

# follow users
Enum.each(followers, fn follower ->
  Accounts.follow_user(me, follower.id)
end)

# each follower creates tweets

Enum.each(followers, fn follower ->
  Enum.each(0..tweets_count, fn _i ->
    Resources.create_tweet(%{
      message: Faker.Lorem.sentence(),
      creator_id: follower.id
    })
  end)
end)
