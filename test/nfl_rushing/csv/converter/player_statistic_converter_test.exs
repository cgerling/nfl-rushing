defmodule NflRushing.CSV.PlayerStatisticConverterTest do
  use ExUnit.Case, async: true
  import NflRushing.Factory

  alias NflRushing.CSV.PlayerStatisticConverter

  describe "convert_to_entry/1" do
    test "returns a list with player statistic information" do
      player_statistic = build(:player_statistic)

      assert PlayerStatisticConverter.convert_to_entry(player_statistic) == [
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
  end

  describe "get_headers/0" do
    test "returns a list with player statistic headers" do
      assert PlayerStatisticConverter.get_headers() == [
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
end
