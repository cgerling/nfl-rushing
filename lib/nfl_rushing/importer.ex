defmodule NflRushing.Importer do
  alias Ecto.Multi
  alias NflRushing.Importer.PlayerParser
  alias NflRushing.Importer.PlayerStatisticParser
  alias NflRushing.Importer.TeamParser
  alias NflRushing.League
  alias NflRushing.Repo

  @spec import_rushing_data(String.t()) :: {:ok, map} | {:error, term}
  def import_rushing_data(file_path) when is_binary(file_path) do
    with {:ok, file} <- File.open(file_path),
         file_content when is_binary(file_content) <- IO.read(file, :all),
         {:ok, data} <- Jason.decode(file_content) do
      save_rushing_data(data)
    end
  end

  defp save_rushing_data(rushing_data) when is_list(rushing_data) do
    Multi.new()
    |> Multi.run(:parsed_teams, fn _, _ ->
      parse_teams_data(rushing_data)
    end)
    |> Multi.run(:teams, fn _, %{parsed_teams: parsed_teams} ->
      save_teams(parsed_teams)
    end)
    |> Multi.run(:parsed_players, fn _, %{teams: teams} ->
      parse_players_data(rushing_data, teams)
    end)
    |> Multi.run(:players, fn _, %{parsed_players: parsed_players} ->
      save_players(parsed_players)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{teams: teams, players: players}} -> {:ok, %{teams: teams, players: players}}
      {:error, _, reason, _} -> {:error, reason}
    end
  end

  defp parse_teams_data(rushing_data) do
    parsed_teams = Enum.map(rushing_data, &TeamParser.parse_data/1)

    {:ok, parsed_teams}
  end

  defp save_teams(parsed_teams) do
    saved_teams = Enum.map(parsed_teams, &League.import_team/1)

    saved_teams
    |> Keyword.get_values(:error)
    |> case do
      [] -> {:ok, Keyword.get_values(saved_teams, :ok)}
      unsaved_teams when is_list(unsaved_teams) -> {:error, unsaved_teams}
    end
  end

  defp parse_players_data(rushing_data, teams) do
    parsed_player_with_statistics =
      Enum.map(rushing_data, &parse_player_with_statistic_data(&1, teams))

    {:ok, parsed_player_with_statistics}
  end

  defp parse_player_with_statistic_data(player_with_statistic_data, teams) do
    player_data = PlayerParser.parse_data(player_with_statistic_data, teams: teams)
    player_statistic_data = PlayerStatisticParser.parse_data(player_with_statistic_data)

    Map.put(player_data, :statistic, player_statistic_data)
  end

  defp save_players(parsed_players) do
    saved_players = Enum.map(parsed_players, &League.import_player_with_statistic/1)

    saved_players
    |> Keyword.get_values(:error)
    |> case do
      [] -> {:ok, Keyword.get_values(saved_players, :ok)}
      unsaved_players when is_list(unsaved_players) -> {:error, unsaved_players}
    end
  end
end
