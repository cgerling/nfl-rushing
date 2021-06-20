defmodule NflRushing.CSV.TeamConverter do
  alias NflRushing.CSV.Converter
  alias NflRushing.League.Team

  @behaviour Converter

  @impl Converter
  @spec convert_to_entry(Team.t()) :: Converter.entry()
  def convert_to_entry(%Team{} = team) do
    [team.abbreviation]
  end

  @impl Converter
  @spec get_headers() :: Converter.headers()
  def get_headers do
    ["abbreviation"]
  end
end
