defmodule NflRushing.CSV.TeamConverterTest do
  use ExUnit.Case, async: true
  import NflRushing.Factory

  alias NflRushing.CSV.TeamConverter

  describe "convert_to_entry/1" do
    test "returns a list with team information" do
      team = build(:team)

      assert TeamConverter.convert_to_entry(team) == [team.abbreviation]
    end
  end

  describe "get_headers/0" do
    test "returns a list with team headers" do
      assert TeamConverter.get_headers() == ["abbreviation"]
    end
  end
end
