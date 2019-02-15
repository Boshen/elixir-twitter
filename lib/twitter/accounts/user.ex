defmodule Twitter.Accounts.User do
  @moduledoc """
  User Schema
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Twitter.Resources.Tweet

  @derive {Jason.Encoder, only: [:id, :name, :inserted_at, :updated_at]}
  schema "users" do
    field :name, :string

    has_many :tweets, Tweet, foreign_key: :creator_id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
