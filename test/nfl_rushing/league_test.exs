defmodule NflRushing.LeagueTest do
  use NflRushing.DataCase, async: true

  alias NflRushing.League

  describe "list_players/1" do
    test "returns a subset of all existing players" do
      players = insert_list(50, :player)

      fetched_players = League.list_players()

      assert Enum.count(fetched_players) == 30

      assert Enum.all?(fetched_players, fn fetched_player ->
               Enum.find(players, &(&1.id == fetched_player.id))
             end)
    end

    test "returns a subset of all players sorted by the newest to the oldest" do
      insert_list(50, :player)

      fetched_players = League.list_players()

      sorted_fetched_players = Enum.sort_by(fetched_players, & &1.inserted_at, :desc)

      assert sorted_fetched_players == fetched_players
    end

    test "returns a specific subset of players" do
      insert_list(50, :player)

      params = %{page: 2}
      fetched_players = League.list_players(params)

      assert Enum.count(fetched_players) == 20
    end

    test "returns a subset of players with custom size" do
      insert_list(50, :player)

      params = %{page: 1, page_size: 50}
      fetched_players = League.list_players(params)

      assert Enum.count(fetched_players) == 50
    end

    test "returns a list of players with statistic and team information" do
      insert_list(50, :player)

      fetched_players = League.list_players()

      assert Enum.all?(fetched_players, &Ecto.assoc_loaded?(&1.team))
      assert Enum.all?(fetched_players, &Ecto.assoc_loaded?(&1.statistic))
    end

    test "returns a list with players which name contains the given query" do
      name = Faker.Person.name()
      named_player = insert(:player, name: name)
      _not_matching_player = insert(:player)

      params = %{@params | q: name}
      fetched_players = League.list_players(params)

      assert Enum.count(fetched_players) == 1

      [fetched_player] = fetched_players
      assert fetched_player.id == named_player.id
    end

    test "returns an empty list when no player exists" do
      fetched_players = League.list_players()

      assert Enum.empty?(fetched_players)
    end
  end
end
