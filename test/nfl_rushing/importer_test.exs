defmodule NflRushing.ImporterTest do
  use NflRushing.DataCase, async: true

  alias NflRushing.Importer
  alias NflRushing.League.Player
  alias NflRushing.League.Team

  describe "import_rushing_data/1" do
    @json_fixtures Path.join(__DIR__, "../support/fixtures/import")
    @valid_json Path.join(@json_fixtures, "valid.json")
    @invalid_team_json Path.join(@json_fixtures, "invalid_team.json")
    @invalid_player_json Path.join(@json_fixtures, "invalid_player.json")

    test "returns a map with a list of players and teams imported from the json file" do
      assert {:ok, %{players: players, teams: teams}} = Importer.import_rushing_data(@valid_json)

      saved_players = Repo.all(Player)
      saved_teams = Repo.all(Team)

      assert Enum.all?(players, &match?(%Player{}, &1))
      assert Enum.all?(teams, &match?(%Team{}, &1))

      assert Enum.count(players) == 10
      assert Enum.count(teams) == 10

      assert Enum.count(saved_players) == 10
      assert Enum.count(saved_teams) == 10
    end

    test "returns an error with the invalid records when one of the teams could not be saved" do
      assert {:error, changesets} = Importer.import_rushing_data(@invalid_team_json)

      changeset_errors = Enum.map(changesets, &errors_on/1)

      assert changeset_errors == [
               %{abbreviation: ["can't be blank"]},
               %{abbreviation: ["can't be blank"]}
             ]
    end

    test "returns an error with the invalid records when one of the players could not be saved" do
      assert {:error, changesets} = Importer.import_rushing_data(@invalid_player_json)

      changeset_errors = Enum.map(changesets, &errors_on/1)

      assert changeset_errors == [
               %{name: ["can't be blank"]},
               %{name: ["can't be blank"]},
               %{position: ["can't be blank"]},
               %{position: ["can't be blank"]}
             ]
    end
  end
end
