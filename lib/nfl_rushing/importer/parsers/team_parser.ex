defmodule NflRushing.Importer.TeamParser do
  @behaviour NflRushing.Importer.Parser

  @impl true
  def parse_data(%{} = team_data, _opts \\ []) do
    %{
      abbreviation: team_data["Team"]
    }
  end
end
