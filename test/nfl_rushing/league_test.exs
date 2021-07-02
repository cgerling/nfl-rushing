defmodule NflRushing.LeagueTest do
  use NflRushing.DataCase, async: true

  alias Ecto.Changeset
  alias NflRushing.League
  alias NflRushing.League.Player
  alias NflRushing.League.PlayerStatistic
  alias NflRushing.League.Team

  describe "list_players/1" do
    @params %{
      page: %{page: 1, page_size: 10},
      search: %{q: nil},
      sort: %{field: nil, direction: nil}
    }

    test "returns a map with a total count and a list with a subset of all existing players" do
      players =
        20
        |> insert_list(:player)
        |> Enum.sort_by(& &1.id, :asc)
        |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})

      assert %{count: count, entries: fetched_players} = League.list_players(@params)

      assert count == 20
      assert Enum.count(fetched_players) == 10

      assert Enum.all?(fetched_players, fn fetched_player ->
               Enum.find(players, &(&1.id == fetched_player.id))
             end)
    end

    test "returns a map with a total count and a list with a subset of all players sorted by the newest to the oldest" do
      players =
        20
        |> insert_list(:player)
        |> Enum.sort_by(& &1.id, :asc)
        |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})

      assert %{entries: fetched_players} = League.list_players(@params)

      expected_players = Enum.take(players, 10)

      assert expected_players == fetched_players
    end

    test "returns a map with a total count and a list with a subset of all players sorted by the newest to the oldest and id" do
      now = NaiveDateTime.utc_now()

      players =
        5
        |> insert_list(:player, inserted_at: now)
        |> Enum.sort_by(& &1.id, :asc)
        |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})

      assert %{entries: fetched_players} = League.list_players(@params)

      assert players == fetched_players
    end

    test "returns a map with a total count and a list with a specific subset of players" do
      _players =
        15
        |> insert_list(:player)
        |> Enum.sort_by(& &1.id, :asc)
        |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})

      params = put_in(@params.page.page, 2)
      assert %{count: count, entries: fetched_players} = League.list_players(params)

      assert count == 15
      assert Enum.count(fetched_players) == 5
    end

    test "returns a map with a total count and a list with a subset of players with custom size" do
      _players =
        20
        |> insert_list(:player)
        |> Enum.sort_by(& &1.id, :asc)
        |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})

      params = put_in(@params.page.page_size, 15)
      assert %{count: count, entries: fetched_players} = League.list_players(params)

      assert count == 20
      assert Enum.count(fetched_players) == 15
    end

    test "returns a map with a total count and list of players with statistic and team information" do
      _players =
        10
        |> insert_list(:player)
        |> Enum.sort_by(& &1.id, :asc)
        |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})

      assert %{count: count, entries: fetched_players} = League.list_players(@params)

      assert count == 10
      assert Enum.all?(fetched_players, &Ecto.assoc_loaded?(&1.team))
      assert Enum.all?(fetched_players, &Ecto.assoc_loaded?(&1.statistic))
    end

    test "returns a map with a total count and a list of players which name contains the given query string" do
      _players =
        15
        |> insert_list(:player)
        |> Enum.sort_by(& &1.id, :asc)
        |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})

      name = Faker.Person.name()
      named_player = insert(:player, name: name)

      params = put_in(@params.search.q, name)
      assert %{count: count, entries: fetched_players} = League.list_players(params)

      assert count == 1
      assert Enum.count(fetched_players) == 1

      [fetched_player] = fetched_players
      assert fetched_player.id == named_player.id
    end

    test "returns a map with a total count and a list of players sorted by a given player statistic field and order" do
      players =
        10
        |> insert_list(:player)
        |> Enum.sort_by(& &1.id, :asc)
        |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})
        |> Enum.sort_by(& &1.statistic.id, :desc)

      sort = %{field: :id, direction: :desc}
      params = put_in(@params.sort, sort)
      assert %{entries: fetched_players} = League.list_players(params)

      assert players == fetched_players
    end

    test "returns a map with a total count as zero and an empty list when there is no players saved" do
      assert %{count: count, entries: fetched_players} = League.list_players(@params)

      assert count == 0
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
      players = insert_list(15, :player)

      csv =
        players
        |> Enum.sort_by(& &1.id, :asc)
        |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})
        |> Enum.take(10)
        |> build_csv()

      assert csv == League.export_players(@params)
    end

    test "returns a subset of all players sorted by the newest to the oldest" do
      players = insert_list(15, :player)

      csv =
        players
        |> Enum.sort_by(& &1.id, :asc)
        |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})
        |> Enum.take(10)
        |> build_csv()

      assert csv == League.export_players(@params)
    end

    test "returns a specific subset of players" do
      players = insert_list(15, :player)

      csv =
        players
        |> Enum.sort_by(& &1.id, :asc)
        |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})
        |> Enum.drop(10)
        |> build_csv()

      params = put_in(@params.page.page, 2)

      assert csv == League.export_players(params)
    end

    test "returns a subset of players with custom size" do
      players = insert_list(15, :player)

      csv =
        players
        |> Enum.sort_by(& &1.id, :asc)
        |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})
        |> build_csv()

      params = put_in(@params.page.page_size, 20)

      assert csv == League.export_players(params)
    end

    test "returns a list with players which name contains the given query" do
      _players = insert_list(15, :player)
      name = Faker.Person.name()
      named_player = insert(:player, name: name)

      csv = build_csv([named_player])

      params = put_in(@params.search.q, name)

      assert csv == League.export_players(params)
    end

    test "returns a list with players sorted by a given player statistic field and order" do
      players = insert_list(15, :player)

      csv =
        players
        |> Enum.sort_by(& &1.id, :asc)
        |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})
        |> Enum.sort_by(& &1.statistic.id, :asc)
        |> Enum.take(10)
        |> build_csv()

      sort = %{field: :id, direction: :asc}
      params = put_in(@params.sort, sort)

      assert csv == League.export_players(params)
    end

    test "returns an empty list when no player exists" do
      csv = build_csv([])

      assert csv == League.export_players(@params)
    end
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

  describe "import_player_with_statistic/1" do
    test "returns a player with statistics when params are valid" do
      team = insert(:team)
      player_statistic = params_for(:player_statistic)
      player = params_for(:player)

      params =
        player
        |> Map.put(:team_id, team.id)
        |> Map.put(:statistic, player_statistic)

      assert {:ok, %Player{statistic: %PlayerStatistic{}} = player} =
               League.import_player_with_statistic(params)

      fetched_player_with_statistic =
        Player
        |> Repo.get(player.id)
        |> Repo.preload(:statistic)

      assert player.name == fetched_player_with_statistic.name
      assert player.position == fetched_player_with_statistic.position

      assert player.statistic.average_rushing_attempts_per_game ==
               player_statistic.average_rushing_attempts_per_game

      assert player.statistic.average_rushing_yards_per_attempt ==
               player_statistic.average_rushing_yards_per_attempt

      assert player.statistic.longest_rush == player_statistic.longest_rush
      assert player.statistic.rushing_attempts == player_statistic.rushing_attempts
      assert player.statistic.rushing_first_downs == player_statistic.rushing_first_downs

      assert player.statistic.rushing_first_downs_percentage ==
               player_statistic.rushing_first_downs_percentage

      assert player.statistic.rushing_fourty_yards_each ==
               player_statistic.rushing_fourty_yards_each

      assert player.statistic.rushing_fumbles == player_statistic.rushing_fumbles

      assert player.statistic.rushing_twenty_yards_each ==
               player_statistic.rushing_twenty_yards_each

      assert player.statistic.rushing_yards_per_game == player_statistic.rushing_yards_per_game

      assert player.statistic.total_rushing_touchdowns ==
               player_statistic.total_rushing_touchdowns

      assert player.statistic.total_rushing_yards == player_statistic.total_rushing_yards
    end

    test "returns an error with a changeset when team id does not exists" do
      team_id = Ecto.UUID.generate()
      player_statistic = params_for(:player_statistic)
      player = params_for(:player)

      params =
        player
        |> Map.put(:team_id, team_id)
        |> Map.put(:statistic, player_statistic)

      assert {:error, %Changeset{} = changeset} = League.import_player_with_statistic(params)
      assert errors_on(changeset) == %{team: ["does not exist"]}
    end

    test "returns an error with a changeset when player required params are not present" do
      invalid_params = %{}

      assert {:error, %Changeset{} = changeset} =
               League.import_player_with_statistic(invalid_params)

      assert errors_on(changeset) == %{
               name: ["can't be blank"],
               position: ["can't be blank"],
               team_id: ["can't be blank"]
             }
    end

    test "returns an error with a changeset when player statistic required params are not present" do
      team = insert(:team)
      invalid_player_statistic = %{}
      player = params_for(:player)

      invalid_params =
        player
        |> Map.put(:team_id, team.id)
        |> Map.put(:statistic, invalid_player_statistic)

      assert {:error, %Changeset{} = changeset} =
               League.import_player_with_statistic(invalid_params)

      assert errors_on(changeset) == %{
               statistic: %{
                 average_rushing_attempts_per_game: ["can't be blank"],
                 average_rushing_yards_per_attempt: ["can't be blank"],
                 longest_rush: ["can't be blank"],
                 rushing_attempts: ["can't be blank"],
                 rushing_first_downs: ["can't be blank"],
                 rushing_first_downs_percentage: ["can't be blank"],
                 rushing_fourty_yards_each: ["can't be blank"],
                 rushing_fumbles: ["can't be blank"],
                 rushing_twenty_yards_each: ["can't be blank"],
                 rushing_yards_per_game: ["can't be blank"],
                 total_rushing_touchdowns: ["can't be blank"],
                 total_rushing_yards: ["can't be blank"]
               }
             }
    end
  end
end
