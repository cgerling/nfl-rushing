defmodule NflRushingWeb.TableComponentTest do
  use NflRushingWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias NflRushingWeb.TableComponent

  describe "render/1" do
    test "renders a table tag with assigns" do
      headers = ["Number"]
      entries = Enum.map(1..4, &List.wrap/1)
      table_component = render_component(TableComponent, headers: headers, entries: entries)

      assert table_component =~ ~s{<table class=\"min-w-full\">}
      assert table_component =~ ~s{<thead class=\"border-b-8 border-opacity-0\">}

      assert table_component =~
               ~s{<tbody class="border-opacity-0 border-t-8 divide-y divide-gray-200">}

      assert table_component =~
               ~s{<th scope="col" class="bg-gray-100 font-semibold px-3 py-5 rounded-l-md text-gray-500 text-center text-sm tracking-wide">Number</th>}

      assert table_component =~
               ~s{<td class="font-normal px-3 py-4 text-gray-600 text-center text-sm whitespace-nowrap">1</td>}

      assert table_component =~
               ~s{<td class="font-normal px-3 py-4 text-gray-600 text-center text-sm whitespace-nowrap">2</td>}

      assert table_component =~
               ~s{<td class="font-normal px-3 py-4 text-gray-600 text-center text-sm whitespace-nowrap">3</td>}

      assert table_component =~
               ~s{<td class="font-normal px-3 py-4 text-gray-600 text-center text-sm whitespace-nowrap">4</td>}
    end

    test "renders a table tag with custom mapper" do
      headers = ["Number"]
      entries = Enum.map(1..4, &List.wrap/1)
      mapper = fn entry -> Enum.map(entry, &Kernel.*(&1, 2)) end

      table_component =
        render_component(TableComponent, headers: headers, entries: entries, mapper: mapper)

      assert table_component =~
               ~s{<td class="font-normal px-3 py-4 text-gray-600 text-center text-sm whitespace-nowrap">2</td>}

      assert table_component =~
               ~s{<td class="font-normal px-3 py-4 text-gray-600 text-center text-sm whitespace-nowrap">4</td>}

      assert table_component =~
               ~s{<td class="font-normal px-3 py-4 text-gray-600 text-center text-sm whitespace-nowrap">6</td>}

      assert table_component =~
               ~s{<td class="font-normal px-3 py-4 text-gray-600 text-center text-sm whitespace-nowrap">8</td>}
    end

    test "renders a table tag without content when entries are not informed" do
      headers = ["Number"]
      entries = []
      table_component = render_component(TableComponent, headers: headers, entries: entries)

      assert table_component =~ ~s{<table class=\"min-w-full\">}
      assert table_component =~ ~s{<thead class=\"border-b-8 border-opacity-0\">}

      assert table_component =~
               ~s{<tbody class="border-opacity-0 border-t-8 divide-y divide-gray-200">}

      assert table_component =~
               ~s{<th scope="col" class="bg-gray-100 font-semibold px-3 py-5 rounded-l-md text-gray-500 text-center text-sm tracking-wide">Number</th>}

      refute table_component =~
               ~s{<td class="font-normal px-3 py-4 text-gray-600 text-center text-sm whitespace-nowrap">}
    end
  end
end
