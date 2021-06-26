defmodule NflRushing.Importer.PlayerStatisticParser do
  @behaviour NflRushing.Importer.Parser

  alias NflRushing.Importer.Parser

  @impl true
  def parse_data(%{} = player_statistic_data, _opts \\ []) do
    longest_rush = Parser.normalize_as_string(player_statistic_data["Lng"])
    total_rushing_yards = Parser.normalize_as_integer(player_statistic_data["Yds"])

    %{
      average_rushing_attempts_per_game: player_statistic_data["Att/G"],
      average_rushing_yards_per_attempt: player_statistic_data["Avg"],
      longest_rush: longest_rush,
      rushing_attempts: player_statistic_data["Att"],
      rushing_first_downs: player_statistic_data["1st"],
      rushing_first_downs_percentage: player_statistic_data["1st%"],
      rushing_fourty_yards_each: player_statistic_data["40+"],
      rushing_fumbles: player_statistic_data["FUM"],
      rushing_twenty_yards_each: player_statistic_data["20+"],
      rushing_yards_per_game: player_statistic_data["Yds/G"],
      total_rushing_touchdowns: player_statistic_data["TD"],
      total_rushing_yards: total_rushing_yards
    }
  end
end
