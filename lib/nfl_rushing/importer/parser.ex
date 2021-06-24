defmodule NflRushing.Importer.Parser do
  @callback parse_data(data :: map, opts :: list) :: map
end
