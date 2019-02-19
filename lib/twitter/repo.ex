defmodule Twitter.Repo do
  use Ecto.Repo, otp_app: :twitter, adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 20

  def paginate_cursor(queryable, opts \\ [], repo_opts \\ []) do
    defaults = [
      limit: 20,
      maximum_limit: 100,
      include_total_count: false,
      total_count_primary_key_field: :id,
      total_count_limit: :infinity
    ]

    opts = Keyword.merge(defaults, opts)
    Paginator.paginate(queryable, opts, __MODULE__, repo_opts)
  end
end
