defmodule NflRushing.LeagueTest do
  use NflRushing.DataCase, async: true

  alias NflRushing.League

  describe "list_players/0" do
    test "returns a list of all players saved with statistic and team associations" do
      players = insert_list(5, :player)

      fetched_players = League.list_players()

      assert Enum.count(fetched_players) == 5

      assert Enum.all?(fetched_players, fn fetched_player ->
               Enum.find(players, &(&1.id == fetched_player.id))
             end)

      assert Enum.all?(fetched_players, &Ecto.assoc_loaded?(&1.team))
      assert Enum.all?(fetched_players, &Ecto.assoc_loaded?(&1.statistic))
    end

    test "returns an empty list when there is no player saved" do
      fetched_players = League.list_players()

      assert Enum.empty?(fetched_players)
    end
  end
end
