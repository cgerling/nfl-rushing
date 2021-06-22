defmodule NflRushing.CSV.PlayerConverterTest do
  use ExUnit.Case, async: true
  import NflRushing.Factory

  alias NflRushing.CSV.PlayerConverter

  describe "convert_to_entry/1" do
    test "returns a list with player information" do
      player = build(:player)

      assert PlayerConverter.convert_to_entry(player) == [player.name, player.position]
    end
  end

  describe "get_headers/0" do
    test "returns a list with player headers" do
      assert PlayerConverter.get_headers() == ["name", "position"]
    end
  end
end
