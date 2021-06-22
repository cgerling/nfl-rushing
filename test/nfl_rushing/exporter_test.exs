defmodule NflRushing.ExporterTest do
  use ExUnit.Case, async: true
  import NflRushing.Factory

  alias NflRushing.Exporter

  describe "export_players/1" do
    @csv_headers "name,position,abbreviation,average_rushing_attempts_per_game,average_rushing_yards_per_attempt,longest_rush,rushing_attempts,rushing_first_downs,rushing_first_downs_percentage,rushing_fourty_yards_each,rushing_fumbles,rushing_twenty_yards_each,rushing_yards_per_game,total_rushing_touchdowns,total_rushing_yards"

    test "returns a CSV formatted string from a list of players" do
      players = build_list(2, :player)

      csv_players =
        Enum.map(players, fn player ->
          %{team: team, statistic: statistic} = player

          entry = [
            player.name,
            player.position,
            team.abbreviation,
            statistic.average_rushing_attempts_per_game,
            statistic.average_rushing_yards_per_attempt,
            statistic.longest_rush,
            statistic.rushing_attempts,
            statistic.rushing_first_downs,
            statistic.rushing_first_downs_percentage,
            statistic.rushing_fourty_yards_each,
            statistic.rushing_fumbles,
            statistic.rushing_twenty_yards_each,
            statistic.rushing_yards_per_game,
            statistic.total_rushing_touchdowns,
            statistic.total_rushing_yards
          ]

          entry
          |> Enum.join(",")
          |> Kernel.<>("\r\n")
        end)

      csv = "#{@csv_headers}\r\n#{csv_players}"

      assert csv == Exporter.export_players(players)
    end

    test "returns an empty CSV when the list is empty" do
      csv = "#{@csv_headers}\r\n"

      assert csv == Exporter.export_players([])
    end
  end
end
