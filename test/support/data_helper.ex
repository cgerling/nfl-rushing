defmodule NflRushing.DataHelper do
  alias Ecto.Changeset

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  @spec errors_on(Changeset.t()) :: %{required(atom) => [String.t() | map]}
  def errors_on(changeset) do
    Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end

  @spec build_csv(list(Player.t())) :: String.t()
  def build_csv(players) when is_list(players) do
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
end
