defmodule Twitter.Resources.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :message, :inserted_at, :updated_at]}
  schema "tweets" do
    field :message, :string

    timestamps()
  end

  @doc false
  def changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [:message])
    |> validate_required([:message])
  end
end
