defmodule NflRushing.CSVTest do
  use ExUnit.Case, async: true

  alias NflRushing.CSV

  describe "export/2" do
    test "returns a string with the list entries formatted as CSV" do
      list = 1..10 |> Enum.to_list() |> Enum.with_index(&[&1, &2])

      csv_list = "1,0\r\n2,1\r\n3,2\r\n4,3\r\n5,4\r\n6,5\r\n7,6\r\n8,7\r\n9,8\r\n10,9\r\n"

      assert csv_list == CSV.export(list)
    end

    test "returns a stream with the list entries formatted as CSV and headers" do
      list = 1..10 |> Enum.to_list() |> Enum.with_index(&[&1, &2])

      csv_list =
        "number,index\r\n1,0\r\n2,1\r\n3,2\r\n4,3\r\n5,4\r\n6,5\r\n7,6\r\n8,7\r\n9,8\r\n10,9\r\n"

      headers = [:number, :index]
      assert csv_list == CSV.export(list, headers: headers)
    end
  end
end
