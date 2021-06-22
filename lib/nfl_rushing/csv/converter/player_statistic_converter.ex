defmodule NflRushing.CSV.PlayerStatisticConverter do
  alias NflRushing.CSV.Converter
  alias NflRushing.League.PlayerStatistic

  @behaviour Converter

  @impl Converter
  @spec convert_to_entry(PlayerStatistic.t()) :: Converter.entry()
  def convert_to_entry(%PlayerStatistic{} = player_statistic) do
    [
      player_statistic.average_rushing_attempts_per_game,
      player_statistic.average_rushing_yards_per_attempt,
      player_statistic.longest_rush,
      player_statistic.rushing_attempts,
      player_statistic.rushing_first_downs,
      player_statistic.rushing_first_downs_percentage,
      player_statistic.rushing_fourty_yards_each,
      player_statistic.rushing_fumbles,
      player_statistic.rushing_twenty_yards_each,
      player_statistic.rushing_yards_per_game,
      player_statistic.total_rushing_touchdowns,
      player_statistic.total_rushing_yards
    ]
  end

  @impl Converter
  @spec get_headers() :: Converter.headers()
  def get_headers do
    [
      "average_rushing_attempts_per_game",
      "average_rushing_yards_per_attempt",
      "longest_rush",
      "rushing_attempts",
      "rushing_first_downs",
      "rushing_first_downs_percentage",
      "rushing_fourty_yards_each",
      "rushing_fumbles",
      "rushing_twenty_yards_each",
      "rushing_yards_per_game",
      "total_rushing_touchdowns",
      "total_rushing_yards"
    ]
  end
end
