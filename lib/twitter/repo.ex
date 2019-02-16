defmodule Twitter.Repo do
  use Ecto.Repo, otp_app: :twitter, adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 20

  def paginate_cursor(queryable, opts \\ [], repo_opts \\ []) do
    defaults = []
    opts = Keyword.merge(defaults, opts)
    Paginator.paginate(queryable, opts, __MODULE__, repo_opts)
  end
end
