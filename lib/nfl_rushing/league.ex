defmodule NflRushing.League do
  alias NflRushing.League.Player
  alias NflRushing.Query
  alias NflRushing.Repo

  @default_page 1
  @default_page_size 30

  @spec list_players(map) :: list(Player.t())
  def list_players(params \\ %{}) do
    page = Map.get(params, :page, @default_page)
    page_size = Map.get(params, :page_size, @default_page_size)

    Player
    |> Query.sort_by(:inserted_at, :desc)
    |> Query.paginate(page: page, page_size: page_size)
    |> Repo.all()
    |> Repo.preload([:statistic, :team])
  end
end
