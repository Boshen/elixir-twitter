defmodule Twitter.Repo.Migrations.AddIndexInsertedAtIdToTweets do
  use Ecto.Migration

  def change do
    create index(:tweets, [:inserted_at, :id])
  end
end
