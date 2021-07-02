defmodule NflRushing.Repo do
  use Ecto.Repo,
    otp_app: :nfl_rushing,
    adapter: Ecto.Adapters.Postgres

  alias Ecto.Queryable
  alias NflRushing.Query

  @spec paginate(Queryable.t(), Keyword.t()) :: term
  def paginate(queryable, opts \\ []) when is_list(opts) do
    page = Keyword.get(opts, :page, 1)
    page_size = Keyword.get(opts, :page_size, 30)

    entries =
      queryable
      |> Query.paginate(page: page, page_size: page_size)
      |> all(opts)

    total_entries = aggregate(queryable, :count)

    %{count: total_entries, entries: entries}
  end
end
