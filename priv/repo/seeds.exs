# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Twitter.Repo.insert!(%Twitter.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Twitter.Repo
alias Twitter.Accounts.User

if !Repo.get_by(User, name: "Superuser") do
  Repo.insert(%User{
    name: "Superuser"
  })
end
