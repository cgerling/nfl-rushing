defmodule NflRushing.CSV do
  alias NimbleCSV.RFC4180, as: CSV

  @spec export(list, Keyword.t()) :: String.t()
  def export(list, opts \\ []) when is_list(list) do
    headers = Keyword.get(opts, :headers, [])

    list
    |> put_headers(headers)
    |> CSV.dump_to_iodata()
    |> IO.iodata_to_binary()
  end

  defp put_headers(list, []),
    do: list

  defp put_headers(list, headers) when is_list(headers),
    do: [headers | list]
end
