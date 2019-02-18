defmodule Twitter.Accounts.Follower do
  @moduledoc """
  Follower Schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :user_id, :follower_id, :inserted_at, :updated_at]}
  schema "followers" do
    field :user_id, :id
    field :follower_id, :id

    @timestamps_opts [type: :utc_datetime_usec]
    timestamps()
  end

  @doc false
  def changeset(follower, attrs) do
    follower
    |> cast(attrs, [:user_id, :follower_id])
    |> validate_required([:user_id, :follower_id])
    |> unique_constraint(:user_id, name: :followers_user_id_follower_id_index)
  end
end
