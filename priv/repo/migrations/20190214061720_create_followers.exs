defmodule Twitter.Repo.Migrations.CreateFollowers do
  use Ecto.Migration

  def change do
    create table(:followers) do
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :follower_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:followers, [:user_id])
    create index(:followers, [:follower_id])
    create index(:followers, [:user_id, :follower_id], unique: true)
  end
end
