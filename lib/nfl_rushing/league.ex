defmodule NflRushing.League do
  alias NflRushing.League.Player
  alias NflRushing.Query
  alias NflRushing.Repo

  @spec list_players(map) :: list(Player.t())
  def list_players(params \\ %{}) do
    Player
    |> Query.sort_by(:inserted_at, :desc)
    |> Query.paginate(page: params.page, page_size: params.page_size)
    |> Repo.all()
    |> Repo.preload([:statistic, :team])
  end
end
