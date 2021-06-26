defmodule NflRushing.Importer.PlayerStatisticParserTest do
  use ExUnit.Case, async: true

  alias NflRushing.Importer.PlayerStatisticParser

  describe "parse_data/2" do
    @values %{
      "Att/G" => :rand.uniform(),
      "Avg" => :rand.uniform(),
      "Lng" => 100 |> :rand.uniform() |> to_string(),
      "Att" => :rand.uniform(100),
      "1st" => :rand.uniform(10),
      "1st%" => :rand.uniform(),
      "40+" => :rand.uniform(100),
      "FUM" => :rand.uniform(100),
      "20+" => :rand.uniform(100),
      "Yds/G" => :rand.uniform(),
      "TD" => :rand.uniform(100),
      "Yds" => :rand.uniform(100)
    }

    test "returns a map with player statistic information" do
      data = @values

      assert PlayerStatisticParser.parse_data(data) == %{
               average_rushing_attempts_per_game: @values["Att/G"],
               average_rushing_yards_per_attempt: @values["Avg"],
               longest_rush: @values["Lng"],
               rushing_attempts: @values["Att"],
               rushing_first_downs: @values["1st"],
               rushing_first_downs_percentage: @values["1st%"],
               rushing_fourty_yards_each: @values["40+"],
               rushing_fumbles: @values["FUM"],
               rushing_twenty_yards_each: @values["20+"],
               rushing_yards_per_game: @values["Yds/G"],
               total_rushing_touchdowns: @values["TD"],
               total_rushing_yards: @values["Yds"]
             }
    end

    test "returns a map with player statistic information with longest rush as a string when it is passed as an integer" do
      longest_rush = :rand.uniform(100)
      longest_rush_string = to_string(longest_rush)

      data = %{@values | "Lng" => longest_rush}

      player_statistic = PlayerStatisticParser.parse_data(data)

      assert player_statistic.longest_rush == longest_rush_string
    end

    test "returns a map with player statistic information with total rushing yards as an integer when it is passed as a string" do
      total_rushing_yards = :rand.uniform(100)
      total_rushing_yards_string = to_string(total_rushing_yards)

      data = %{@values | "Yds" => total_rushing_yards_string}

      player_statistic = PlayerStatisticParser.parse_data(data)

      assert player_statistic.total_rushing_yards == total_rushing_yards
    end

    test "returns a map with player statistic information with total rushing yards as an integer when it is passed as a string with commas" do
      total_rushing_yards = 4502
      total_rushing_yards_string = "4,502"

      data = %{@values | "Yds" => total_rushing_yards_string}

      player_statistic = PlayerStatisticParser.parse_data(data)

      assert player_statistic.total_rushing_yards == total_rushing_yards
    end

    test "returns a map with nil values when information is not present" do
      data = %{}

      assert PlayerStatisticParser.parse_data(data) == %{
               average_rushing_attempts_per_game: nil,
               average_rushing_yards_per_attempt: nil,
               longest_rush: "",
               rushing_attempts: nil,
               rushing_first_downs: nil,
               rushing_first_downs_percentage: nil,
               rushing_fourty_yards_each: nil,
               rushing_fumbles: nil,
               rushing_twenty_yards_each: nil,
               rushing_yards_per_game: nil,
               total_rushing_touchdowns: nil,
               total_rushing_yards: nil
             }
    end
  end
end
