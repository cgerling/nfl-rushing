defmodule NflRushing.Importer.PlayerParserTest do
  use ExUnit.Case, async: true

  import NflRushing.Factory

  alias NflRushing.Importer.PlayerParser

  describe "parse_data/2" do
    test "returns a map with player information and team id" do
      name = Faker.Person.name()

      position =
        2
        |> Faker.Lorem.characters()
        |> List.to_string()
        |> String.upcase()

      teams = build_list(5, :team)
      team = Enum.random(teams)

      data = %{"Player" => name, "Pos" => position, "Team" => team.abbreviation}

      assert PlayerParser.parse_data(data, teams: teams) == %{
               name: name,
               position: position,
               team_id: team.id
             }
    end

    test "returns a map with player information and team id as nil when team is not passed" do
      name = Faker.Person.name()

      position =
        2
        |> Faker.Lorem.characters()
        |> List.to_string()
        |> String.upcase()

      data = %{"Player" => name, "Pos" => position, "Team" => "some team"}

      assert PlayerParser.parse_data(data) == %{
               name: name,
               position: position,
               team_id: nil
             }
    end

    test "returns a map with nil values when information is not present" do
      data = %{}

      assert PlayerParser.parse_data(data) == %{
               name: nil,
               position: nil,
               team_id: nil
             }
    end
  end
end
