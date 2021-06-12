defmodule NflRushingWeb.PlayerStatisticView do
  use NflRushingWeb, :view

  @spec render(String.t(), map) :: map

  def render("player_statistic.json", %{player_statistic: player_statistic}) do
    %{
      average_rushing_attempts_per_game: player_statistic.average_rushing_attempts_per_game,
      average_rushing_yards_per_attempt: player_statistic.average_rushing_yards_per_attempt,
      longest_rush: player_statistic.longest_rush,
      rushing_attempts: player_statistic.rushing_attempts,
      rushing_first_downs: player_statistic.rushing_first_downs,
      rushing_first_downs_percentage: player_statistic.rushing_first_downs_percentage,
      rushing_fourty_yards_each: player_statistic.rushing_fourty_yards_each,
      rushing_fumbles: player_statistic.rushing_fumbles,
      rushing_twenty_yards_each: player_statistic.rushing_twenty_yards_each,
      rushing_yards_per_game: player_statistic.rushing_yards_per_game,
      total_rushing_touchdows: player_statistic.total_rushing_touchdows,
      total_rushing_yards: player_statistic.total_rushing_yards
    }
  end
end
