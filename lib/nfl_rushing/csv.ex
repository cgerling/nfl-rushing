defmodule NflRushing.CSV do
  alias NimbleCSV.RFC4180, as: CSV

  @spec export_to_stream(list, Keyword.t()) :: Stream.t()
  def export_to_stream(list, opts \\ []) when is_list(list) do
    headers = Keyword.get(opts, :headers, [])

    list
    |> put_headers(headers)
    |> CSV.dump_to_stream()
  end

  defp put_headers(list, []),
    do: list

  defp put_headers(list, headers) when is_list(headers),
    do: [headers | list]
end
