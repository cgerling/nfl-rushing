defmodule NflRushing.Exporter do
  alias NflRushing.CSV
  alias NflRushing.CSV.PlayerConverter
  alias NflRushing.CSV.PlayerStatisticConverter
  alias NflRushing.CSV.TeamConverter
  alias NflRushing.League.Player

  @spec export_players(list(Player.t())) :: String.t()
  def export_players(players) when is_list(players) do
    headers =
      [PlayerConverter, TeamConverter, PlayerStatisticConverter]
      |> Enum.map(& &1.get_headers())
      |> List.flatten()

    players
    |> Enum.map(&convert_player_to_entry/1)
    |> CSV.export(headers: headers)
  end

  defp convert_player_to_entry(%Player{} = player) do
    entry = [
      PlayerConverter.convert_to_entry(player),
      TeamConverter.convert_to_entry(player.team),
      PlayerStatisticConverter.convert_to_entry(player.statistic)
    ]

    List.flatten(entry)
  end
end
