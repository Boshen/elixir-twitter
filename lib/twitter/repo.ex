defmodule Twitter.Repo do
  use Ecto.Repo, otp_app: :twitter, adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 20
end
