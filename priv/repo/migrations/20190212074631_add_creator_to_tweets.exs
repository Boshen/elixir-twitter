defmodule Twitter.Repo.Migrations.AddCreatorToTweets do
  use Ecto.Migration

  def change do
    alter table(:tweets) do
      add :creator_id, references(:users), null: false
      modify :message, :string, null: false
    end
  end
end
