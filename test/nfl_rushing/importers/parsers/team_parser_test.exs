defmodule NflRushing.Importer.TeamParserTest do
  use ExUnit.Case, async: true

  alias NflRushing.Importer.TeamParser

  describe "parse_data/2" do
    test "returns a map with team information" do
      abbreviation = Faker.Team.name() |> String.upcase() |> String.slice(1..3)
      data = %{"Team" => abbreviation}

      assert TeamParser.parse_data(data) == %{abbreviation: abbreviation}
    end

    test "returns a map with nil values when information is not present" do
      data = %{}

      assert TeamParser.parse_data(data) == %{abbreviation: nil}
    end
  end
end
