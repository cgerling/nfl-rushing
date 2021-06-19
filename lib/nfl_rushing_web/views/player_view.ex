defmodule NflRushingWeb.PlayerView do
  use NflRushingWeb, :view

  alias NflRushingWeb.PlayerStatisticView
  alias NflRushingWeb.TeamView

  @spec render(String.t(), map) :: map

  def render("index.json", %{players: players}) do
    %{data: render_many(players, __MODULE__, "player.json")}
  end

  def render("player.json", %{player: player}) do
    %{
      name: player.name,
      position: player.position,
      statistic: render_one(player.statistic, PlayerStatisticView, "player_statistic.json"),
      team: render_one(player.team, TeamView, "team.json")
    }
  end
end
