defmodule NflRushing.CSV.PlayerConverter do
  alias NflRushing.CSV.Converter
  alias NflRushing.League.Player

  @behaviour Converter

  @impl Converter
  @spec convert_to_entry(Player.t()) :: Converter.entry()
  def convert_to_entry(%Player{} = player) do
    [player.name, player.position]
  end

  @impl Converter
  @spec get_headers() :: Converter.headers()
  def get_headers do
    ["name", "position"]
  end
end
