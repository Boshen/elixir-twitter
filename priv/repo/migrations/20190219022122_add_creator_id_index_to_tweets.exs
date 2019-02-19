defmodule Twitter.Repo.Migrations.AddCreatorIdIndexToTweets do
  use Ecto.Migration

  def change do
    create index(:tweets, [:creator_id])
  end
end
