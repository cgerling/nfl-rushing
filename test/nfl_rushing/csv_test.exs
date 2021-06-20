defmodule NflRushing.CSVTest do
  use ExUnit.Case, async: true

  alias NflRushing.CSV

  describe "export_to_stream/2" do
    test "returns a stream with the list entries formatted as CSV" do
      list = 1..10 |> Enum.to_list() |> Enum.with_index(&[&1, &2])

      csv_list = [
        ["1", 44, "0", "\r\n"],
        ["2", 44, "1", "\r\n"],
        ["3", 44, "2", "\r\n"],
        ["4", 44, "3", "\r\n"],
        ["5", 44, "4", "\r\n"],
        ["6", 44, "5", "\r\n"],
        ["7", 44, "6", "\r\n"],
        ["8", 44, "7", "\r\n"],
        ["9", 44, "8", "\r\n"],
        ["10", 44, "9", "\r\n"]
      ]

      stream = CSV.export_to_stream(list)

      assert csv_list == Enum.to_list(stream)
    end

    test "returns a stream with the list entries formatted as CSV and headers" do
      list = 1..10 |> Enum.to_list() |> Enum.with_index(&[&1, &2])

      csv_list = [
        ["number", 44, "index", "\r\n"],
        ["1", 44, "0", "\r\n"],
        ["2", 44, "1", "\r\n"],
        ["3", 44, "2", "\r\n"],
        ["4", 44, "3", "\r\n"],
        ["5", 44, "4", "\r\n"],
        ["6", 44, "5", "\r\n"],
        ["7", 44, "6", "\r\n"],
        ["8", 44, "7", "\r\n"],
        ["9", 44, "8", "\r\n"],
        ["10", 44, "9", "\r\n"]
      ]

      headers = [:number, :index]
      stream = CSV.export_to_stream(list, headers: headers)

      assert csv_list == Enum.to_list(stream)
    end
  end
end
