defmodule NflRushing.League do
  alias NflRushing.League.Player
  alias NflRushing.Repo

  @spec list_players() :: list(Player.t())
  def list_players do
    Player
    |> Repo.all()
    |> Repo.preload([:statistic, :team])
  end
end
