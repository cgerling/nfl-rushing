defmodule NflRushingWeb.TableComponentTest do
  use NflRushingWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias NflRushingWeb.TableComponent

  describe "render/1" do
    test "renders a table tag with assigns" do
      headers = ["Number"]
      entries = Enum.map(1..4, &List.wrap/1)

      assert {:ok, table_component} =
               TableComponent
               |> render_component(headers: headers, entries: entries)
               |> Floki.parse_fragment()

      assert [table_element] = Floki.find(table_component, "table")

      assert ["Number"] ==
               table_element
               |> Floki.find("thead tr th")
               |> Enum.map(&Floki.text/1)

      assert ["1", "2", "3", "4"] ==
               table_element
               |> Floki.find("tbody tr td")
               |> Enum.map(&Floki.text/1)
    end

    test "renders a table tag with custom mapper" do
      headers = ["Number"]
      entries = Enum.map(1..4, &List.wrap/1)
      mapper = fn entry -> Enum.map(entry, &Kernel.*(&1, 2)) end

      assert {:ok, table_component} =
               TableComponent
               |> render_component(headers: headers, entries: entries, mapper: mapper)
               |> Floki.parse_fragment()

      assert [table_element] = Floki.find(table_component, "table")

      assert ["2", "4", "6", "8"] ==
               table_element
               |> Floki.find("tbody tr td")
               |> Enum.map(&Floki.text/1)
    end

    test "renders a table tag with no content body when entries are empty" do
      headers = ["Number"]
      entries = []

      assert {:ok, table_component} =
               TableComponent
               |> render_component(headers: headers, entries: entries)
               |> Floki.parse_fragment()

      assert [table_element] = Floki.find(table_component, "table")

      assert ["Number"] ==
               table_element
               |> Floki.find("thead tr th")
               |> Enum.map(&Floki.text/1)

      assert [] == Floki.find(table_element, "tbody tr td")
    end
  end
end
