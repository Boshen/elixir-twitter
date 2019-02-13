defmodule Twitter.Resources.Tweet do
  @moduledoc """
  Tweet Schema
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Twitter.Accounts.User

  @derive {Jason.Encoder, only: [:id, :message, :inserted_at, :updated_at, :creator_id, :creator]}
  schema "tweets" do
    field :message, :string

    field :creator, :map, virtual: true
    belongs_to :user, User, foreign_key: :creator_id

    timestamps()
  end

  @doc false
  def changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [:message, :creator_id])
    |> validate_required([:message])
    |> assoc_constraint(:user)
  end

  @doc false
  def check_insert(tweet, attrs) do
    tweet
    |> changeset(attrs)
    |> validate_required([:creator_id])
    |> assoc_constraint(:user)
  end
end
