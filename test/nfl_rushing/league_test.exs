defmodule NflRushing.LeagueTest do
  use NflRushing.DataCase, async: true

  alias Ecto.Changeset
  alias NflRushing.League
  alias NflRushing.League.Team

  describe "list_players/1" do
    @params %{
      page: %{page: 1, page_size: 10},
      search: %{q: nil},
      sort: %{field: nil, direction: nil}
    }

    test "returns a subset of all existing players" do
      players = insert_list(20, :player)

      fetched_players = League.list_players(@params)

      assert Enum.count(fetched_players) == 10

      assert Enum.all?(fetched_players, fn fetched_player ->
               Enum.find(players, &(&1.id == fetched_player.id))
             end)
    end

    test "returns a subset of all players sorted by the newest to the oldest" do
      insert_list(20, :player)

      fetched_players = League.list_players(@params)

      sorted_fetched_players = Enum.sort_by(fetched_players, & &1.inserted_at, :desc)

      assert sorted_fetched_players == fetched_players
    end

    test "returns a specific subset of players" do
      insert_list(15, :player)

      params = put_in(@params.page.page, 2)
      fetched_players = League.list_players(params)

      assert Enum.count(fetched_players) == 5
    end

    test "returns a subset of players with custom size" do
      insert_list(20, :player)

      params = put_in(@params.page.page_size, 20)
      fetched_players = League.list_players(params)

      assert Enum.count(fetched_players) == 20
    end

    test "returns a list of players with statistic and team information" do
      insert_list(10, :player)

      fetched_players = League.list_players(@params)

      assert Enum.all?(fetched_players, &Ecto.assoc_loaded?(&1.team))
      assert Enum.all?(fetched_players, &Ecto.assoc_loaded?(&1.statistic))
    end

    test "returns a list with players which name contains the given query" do
      name = Faker.Person.name()
      named_player = insert(:player, name: name)
      _not_matching_player = insert(:player)

      params = put_in(@params.search.q, name)
      fetched_players = League.list_players(params)

      assert Enum.count(fetched_players) == 1

      [fetched_player] = fetched_players
      assert fetched_player.id == named_player.id
    end

    test "returns a list with players sorted by a given field and order" do
      insert_list(10, :player)

      sort = %{field: :name, direction: :desc}
      params = put_in(@params.sort, sort)
      fetched_players = League.list_players(params)

      sorted_players = Enum.sort_by(fetched_players, & &1.name, :desc)

      assert fetched_players == sorted_players
    end

    test "returns an empty list when no player exists" do
      fetched_players = League.list_players(@params)

      assert Enum.empty?(fetched_players)
    end
  end

  describe "export_players/1" do
    @params %{
      page: %{page: 1, page_size: 10},
      search: %{q: nil},
      sort: %{field: nil, direction: nil}
    }

    test "returns a subset of all existing players" do
      players = insert_list(5, :player)

      csv = build_csv(players)

      assert csv == League.export_players(@params)
    end

    test "returns a subset of all players sorted by the newest to the oldest" do
      players = insert_list(5, :player)

      csv =
        players
        |> Enum.sort_by(& &1.inserted_at, :desc)
        |> build_csv()

      assert csv == League.export_players(@params)
    end

    test "returns a specific subset of players" do
      players = insert_list(20, :player)

      csv =
        players
        |> Enum.sort_by(& &1.inserted_at, :desc)
        |> Enum.drop(10)
        |> build_csv()

      params = put_in(@params.page.page, 2)

      assert csv == League.export_players(params)
    end

    test "returns a subset of players with custom size" do
      players = insert_list(20, :player)

      csv =
        players
        |> Enum.sort_by(& &1.inserted_at, :desc)
        |> build_csv()

      params = put_in(@params.page.page_size, 20)

      assert csv == League.export_players(params)
    end

    test "returns a list with players which name contains the given query" do
      name = Faker.Person.name()
      named_player = insert(:player, name: name)
      _not_matching_player = insert(:player)

      csv = build_csv([named_player])

      params = put_in(@params.search.q, name)

      assert csv == League.export_players(params)
    end

    test "returns a list with players sorted by a given field and order" do
      players = insert_list(10, :player)

      csv =
        players
        |> Enum.sort_by(& &1.name, :asc)
        |> build_csv()

      sort = %{field: :name, direction: :asc}
      params = put_in(@params.sort, sort)

      assert csv == League.export_players(params)
    end

    test "returns an empty list when no player exists" do
      csv = build_csv([])

      assert csv == League.export_players(@params)
    end
  end

  defp build_csv(players) when is_list(players) do
    headers =
      "name,position,abbreviation,average_rushing_attempts_per_game,average_rushing_yards_per_attempt,longest_rush,rushing_attempts,rushing_first_downs,rushing_first_downs_percentage,rushing_fourty_yards_each,rushing_fumbles,rushing_twenty_yards_each,rushing_yards_per_game,total_rushing_touchdowns,total_rushing_yards"

    entries = convert_to_csv_entries(players)

    "#{headers}\r\n#{entries}"
  end

  defp convert_to_csv_entries([]), do: ""

  defp convert_to_csv_entries(players) do
    entries =
      players
      |> Enum.map(fn player ->
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

        Enum.join(entry, ",")
      end)
      |> Enum.join("\r\n")

    "#{entries}\r\n"
  end

  describe "import_team/1" do
    test "returns a team when params are valid" do
      params = params_for(:team)

      assert {:ok, %Team{} = team} = League.import_team(params)

      fetched_team = Repo.get(Team, team.id)
      assert team.abbreviation == fetched_team.abbreviation
    end

    test "returns an error with a changeset when required params are not present" do
      invalid_params = %{}

      assert {:error, %Changeset{} = changeset} = League.import_team(invalid_params)
      assert errors_on(changeset) == %{abbreviation: ["can't be blank"]}
    end
  end
end
