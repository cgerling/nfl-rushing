defmodule NflRushing.League do
  alias NflRushing.Exporter
  alias NflRushing.League.Player
  alias NflRushing.Query
  alias NflRushing.Repo

  @spec list_players(map) :: list(Player.t())
  def list_players(%{} = params) do
    %{page: page, search: search, sort: sort} = params

    Player
    |> Query.contains(:name, search.q)
    |> Query.sort_by(sort.field, sort.direction)
    |> Query.paginate(page: page.page, page_size: page.page_size)
    |> Repo.all()
    |> Repo.preload([:statistic, :team])
  end

  @spec export_players(map) :: String.t()
  def export_players(%{} = params) do
    params
    |> list_players()
    |> Exporter.export_players()
  end
end
