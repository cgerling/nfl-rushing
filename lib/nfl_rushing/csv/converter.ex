defmodule NflRushing.CSV.Converter do
  @type entry :: list(String.t() | number)
  @callback convert_to_entry(struct) :: entry

  @type headers :: list(String.t())
  @callback get_headers() :: headers
end
