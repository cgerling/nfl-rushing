defmodule NflRushing.Importer.PlayerParser do
  @behaviour NflRushing.Importer.Parser

  @impl true
  def parse_data(%{} = player_data, opts \\ []) when is_list(opts) do
    teams = Keyword.get(opts, :teams, [])
    team_abbreviation = player_data["Team"]

    team_id =
      teams
      |> Enum.find(%{}, &(&1.abbreviation == team_abbreviation))
      |> Map.get(:id, nil)

    %{
      name: player_data["Player"],
      position: player_data["Pos"],
      team_id: team_id
    }
  end
end
