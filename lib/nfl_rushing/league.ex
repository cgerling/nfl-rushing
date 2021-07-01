defmodule NflRushing.League do
  alias Ecto.Changeset
  alias NflRushing.Exporter
  alias NflRushing.League.Player
  alias NflRushing.League.Team
  alias NflRushing.Query
  alias NflRushing.Repo

  @spec list_players(map) :: list(Player.t())
  def list_players(%{} = params) do
    %{page: page, search: search, sort: sort} = params
    sort_field = Map.get(sort, :field)
    sort_direction = Map.get(sort, :direction)

    Player
    |> Query.contains(:name, search.q)
    |> Query.join_with(:statistic)
    |> Query.sort_by(sort_field, sort_direction, of: :statistic)
    |> Query.sort_by(:inserted_at, :desc)
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

  @spec import_team(map) :: {:ok, Team.t()} | {:error, Changeset.t()}
  def import_team(%{} = params) do
    %Team{}
    |> Team.changeset(params)
    |> Repo.insert()
  end

  @spec import_player_with_statistic(map) :: {:ok, Player.t()} | {:error, Changeset.t()}
  def import_player_with_statistic(%{} = params) do
    params
    |> Player.import_changeset()
    |> Repo.insert()
  end
end
