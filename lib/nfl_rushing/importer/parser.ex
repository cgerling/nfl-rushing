defmodule NflRushing.Importer.Parser do
  @callback parse_data(data :: map, opts :: list) :: map

  @spec normalize_as_string(term) :: String.t()
  def normalize_as_string(value) do
    to_string(value)
  end

  @spec normalize_as_integer(term) :: integer
  def normalize_as_integer(value) when is_binary(value) do
    value
    |> String.replace(",", "")
    |> String.to_integer()
  end

  def normalize_as_integer(value) when is_integer(value) do
    value
  end

  def normalize_as_integer(_value) do
    nil
  end
end
