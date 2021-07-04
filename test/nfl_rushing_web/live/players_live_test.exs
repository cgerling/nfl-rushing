defmodule NflRushingWeb.PlayersLiveTest do
  use NflRushingWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  @players_path "/"

  describe "mount" do
    test "disconnected mount", %{conn: conn} do
      html = conn |> get(@players_path) |> html_response(:ok)

      assert html =~ "NFL Rushing Statistics"
    end

    test "connected mount", %{conn: conn} do
      {:ok, live, _} = live(conn, @players_path)
      rendered = render(live)

      assert rendered =~ "NFL Rushing Statistics"
    end
  end

  describe "search" do
    test "shows search bar", %{conn: conn} do
      {:ok, live, _} = live(conn, @players_path)

      {:ok, live_fragment} =
        live
        |> render()
        |> Floki.parse_fragment()

      assert [search_input] = Floki.find(live_fragment, "input[name=q]")

      assert ["text"] == Floki.attribute(search_input, "type")
      assert ["Player search..."] == Floki.attribute(search_input, "placeholder")
    end

    test "allows to search players by name", %{conn: conn} do
      players = insert_list(10, :player)
      {:ok, live, _} = live(conn, @players_path)

      player = Enum.random(players)

      _form_search =
        live
        |> form("form", %{q: player.name})
        |> render_change()

      {:ok, search_results_fragment} =
        live
        |> render()
        |> Floki.parse_fragment()

      assert [search_input] = Floki.find(search_results_fragment, "form input[name=q]")

      assert [player.name] == Floki.attribute(search_input, "value")

      search_results_count = search_results_fragment |> Floki.find("tbody tr") |> Enum.count()
      assert search_results_count == 1
    end
  end

  describe "sort" do
    test "shows sort menu", %{conn: conn} do
      {:ok, live, _} = live(conn, @players_path)

      {:ok, live_fragment} =
        live
        |> render()
        |> Floki.parse_fragment()

      assert [sort_select] = Floki.find(live_fragment, "select[name=sort]")
      sort_options = sort_select |> Floki.children() |> Enum.map(&Floki.text/1)

      assert sort_options == [
               "Newest to oldest",
               "Less Yds",
               "Most Yds",
               "Less Lng",
               "Most Lng",
               "Less TD",
               "Most TD"
             ]
    end

    test "allows to sort players by creation time descending", %{conn: conn} do
      _players = insert_list(5, :player)
      {:ok, live, _} = live(conn, @players_path)

      {:ok, default_sort_fragment} =
        live
        |> render()
        |> Floki.parse_fragment()

      assert [selected_option] =
               Floki.find(default_sort_fragment, "form select[name=sort] option[selected]")

      assert [""] == Floki.attribute(selected_option, "value")
      assert "Newest to oldest" == Floki.text(selected_option)
    end

    test "allows to sort players by total rushing yards ascending", %{conn: conn} do
      players = insert_list(5, :player)
      {:ok, live, _} = live(conn, @players_path)

      _sort_players =
        live
        |> form("form", %{sort: "total_rushing_yards:asc"})
        |> render_change()

      {:ok, total_rushing_yards_sort_fragment} =
        live
        |> render()
        |> Floki.parse_fragment()

      assert [selected_option] =
               Floki.find(
                 total_rushing_yards_sort_fragment,
                 "form select[name=sort] option[selected]"
               )

      assert ["total_rushing_yards:asc"] == Floki.attribute(selected_option, "value")
      assert "Less Yds" == Floki.text(selected_option)

      expected_order =
        players
        |> Enum.sort_by(& &1.id, :asc)
        |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})
        |> Enum.sort_by(& &1.statistic.total_rushing_yards, :asc)
        |> Enum.map(& &1.name)

      actual_order =
        total_rushing_yards_sort_fragment
        |> Floki.find("table tbody tr td:first-child")
        |> Enum.map(&Floki.text/1)

      assert expected_order == actual_order
    end

    test "allows to sort players by total rushing yards descending", %{conn: conn} do
      players = insert_list(5, :player)
      {:ok, live, _} = live(conn, @players_path)

      _sort_players =
        live
        |> form("form", %{sort: "total_rushing_yards:desc"})
        |> render_change()

      {:ok, total_rushing_yards_sort_fragment} =
        live
        |> render()
        |> Floki.parse_fragment()

      assert [selected_option] =
               Floki.find(
                 total_rushing_yards_sort_fragment,
                 "form select[name=sort] option[selected]"
               )

      assert ["total_rushing_yards:desc"] == Floki.attribute(selected_option, "value")
      assert "Most Yds" == Floki.text(selected_option)

      expected_order =
        players
        |> Enum.sort_by(& &1.id, :asc)
        |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})
        |> Enum.sort_by(& &1.statistic.total_rushing_yards, :desc)
        |> Enum.map(& &1.name)

      actual_order =
        total_rushing_yards_sort_fragment
        |> Floki.find("table tbody tr td:first-child")
        |> Enum.map(&Floki.text/1)

      assert expected_order == actual_order
    end

    test "allows to sort players by longest rush ascending", %{conn: conn} do
      players = insert_list(5, :player)
      {:ok, live, _} = live(conn, @players_path)

      _sort_players =
        live
        |> form("form", %{sort: "longest_rush:asc"})
        |> render_change()

      {:ok, longest_rush_sort_fragment} =
        live
        |> render()
        |> Floki.parse_fragment()

      assert [selected_option] =
               Floki.find(
                 longest_rush_sort_fragment,
                 "form select[name=sort] option[selected]"
               )

      assert ["longest_rush:asc"] == Floki.attribute(selected_option, "value")
      assert "Less Lng" == Floki.text(selected_option)

      expected_order =
        players
        |> Enum.sort_by(& &1.id, :asc)
        |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})
        |> Enum.sort_by(& &1.statistic.longest_rush, :asc)
        |> Enum.map(& &1.name)

      actual_order =
        longest_rush_sort_fragment
        |> Floki.find("table tbody tr td:first-child")
        |> Enum.map(&Floki.text/1)

      assert expected_order == actual_order
    end

    test "allows to sort players by longest rush descending", %{conn: conn} do
      players = insert_list(5, :player)
      {:ok, live, _} = live(conn, @players_path)

      _sort_players =
        live
        |> form("form", %{sort: "longest_rush:desc"})
        |> render_change()

      {:ok, longest_rush_sort_fragment} =
        live
        |> render()
        |> Floki.parse_fragment()

      assert [selected_option] =
               Floki.find(
                 longest_rush_sort_fragment,
                 "form select[name=sort] option[selected]"
               )

      assert ["longest_rush:desc"] == Floki.attribute(selected_option, "value")
      assert "Most Lng" == Floki.text(selected_option)

      expected_order =
        players
        |> Enum.sort_by(& &1.id, :asc)
        |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})
        |> Enum.sort_by(& &1.statistic.longest_rush, :desc)
        |> Enum.map(& &1.name)

      actual_order =
        longest_rush_sort_fragment
        |> Floki.find("table tbody tr td:first-child")
        |> Enum.map(&Floki.text/1)

      assert expected_order == actual_order
    end

    test "allows to sort players by total rushing touchdowns ascending", %{conn: conn} do
      players = insert_list(5, :player)
      {:ok, live, _} = live(conn, @players_path)

      _sort_players =
        live
        |> form("form", %{sort: "total_rushing_touchdowns:asc"})
        |> render_change()

      {:ok, total_rushing_touchdowns_sort_fragment} =
        live
        |> render()
        |> Floki.parse_fragment()

      assert [selected_option] =
               Floki.find(
                 total_rushing_touchdowns_sort_fragment,
                 "form select[name=sort] option[selected]"
               )

      assert ["total_rushing_touchdowns:asc"] == Floki.attribute(selected_option, "value")
      assert "Less TD" == Floki.text(selected_option)

      expected_order =
        players
        |> Enum.sort_by(& &1.id, :asc)
        |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})
        |> Enum.sort_by(& &1.statistic.total_rushing_touchdowns, :asc)
        |> Enum.map(& &1.name)

      actual_order =
        total_rushing_touchdowns_sort_fragment
        |> Floki.find("table tbody tr td:first-child")
        |> Enum.map(&Floki.text/1)

      assert expected_order == actual_order
    end

    test "allows to sort players by total rushing touchdowns descending", %{conn: conn} do
      players = insert_list(5, :player)
      {:ok, live, _} = live(conn, @players_path)

      _sort_players =
        live
        |> form("form", %{sort: "total_rushing_touchdowns:desc"})
        |> render_change()

      {:ok, total_rushing_touchdowns_sort_fragment} =
        live
        |> render()
        |> Floki.parse_fragment()

      assert [selected_option] =
               Floki.find(
                 total_rushing_touchdowns_sort_fragment,
                 "form select[name=sort] option[selected]"
               )

      assert ["total_rushing_touchdowns:desc"] == Floki.attribute(selected_option, "value")
      assert "Most TD" == Floki.text(selected_option)

      expected_order =
        players
        |> Enum.sort_by(& &1.id, :asc)
        |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})
        |> Enum.sort_by(& &1.statistic.total_rushing_touchdowns, :desc)
        |> Enum.map(& &1.name)

      actual_order =
        total_rushing_touchdowns_sort_fragment
        |> Floki.find("table tbody tr td:first-child")
        |> Enum.map(&Floki.text/1)

      assert expected_order == actual_order
    end
  end

  describe "players" do
    test "shows players information", %{conn: conn} do
      {:ok, live, _} = live(conn, @players_path)

      {:ok, live_fragment} =
        live
        |> render()
        |> Floki.parse_fragment()

      assert [players_table] = Floki.find(live_fragment, "table")

      headers =
        players_table
        |> Floki.find("thead tr th")
        |> Enum.map(&Floki.text/1)

      assert headers == [
               "Player",
               "Team",
               "Position",
               "Att/G",
               "Att",
               "Yds",
               "Avg",
               "Yds/G",
               "TD",
               "Lng",
               "1st",
               "1st%",
               "20+",
               "40+",
               "FUM"
             ]

      assert Floki.find(players_table, "tbody tr") == []
    end

    test "show players information with a limit", %{conn: conn} do
      insert_list(50, :player)
      {:ok, live, _} = live(conn, @players_path)

      {:ok, live_fragment} =
        live
        |> render()
        |> Floki.parse_fragment()

      assert [players_table] = Floki.find(live_fragment, "table")

      entries = Floki.find(players_table, "tbody tr")
      assert Enum.count(entries) == 30
    end
  end

  describe "pagination" do
    test "shows pagination controls", %{conn: conn} do
      {:ok, live, _} = live(conn, @players_path)

      {:ok, live_fragment} =
        live
        |> render()
        |> Floki.parse_fragment()

      assert [pagination_controls] = Floki.find(live_fragment, "section")

      assert [previous_button] = Floki.find(pagination_controls, "a[role=button]:first-child")
      assert Floki.text(previous_button) =~ "Previous"

      assert [next_button] = Floki.find(pagination_controls, "a[role=button]:last-child")
      assert Floki.text(next_button) =~ "Next"
    end

    test "shows pagination information", %{conn: conn} do
      insert_list(50, :player)
      {:ok, live, _} = live(conn, @players_path)

      {:ok, live_fragment} =
        live
        |> render()
        |> Floki.parse_fragment()

      assert [page_information_section] = Floki.find(live_fragment, "nav div p")

      page_information_text =
        page_information_section
        |> Floki.text()
        |> String.split(" ", trim: true)
        |> Enum.map(&String.trim/1)
        |> Enum.join(" ")

      assert page_information_text =~ "Showing 1 to 30 of 50 results"
    end

    test "shows pagination information with last index in page when current page is smaller than page size",
         %{conn: conn} do
      insert_list(15, :player)
      {:ok, live, _} = live(conn, @players_path)

      {:ok, live_fragment} =
        live
        |> render()
        |> Floki.parse_fragment()

      assert [page_information_section] = Floki.find(live_fragment, "nav div p")

      page_information_text =
        page_information_section
        |> Floki.text()
        |> String.split(" ", trim: true)
        |> Enum.map(&String.trim/1)
        |> Enum.join(" ")

      assert page_information_text =~ "Showing 1 to 15 of 15 results"
    end

    test "allows to navigate between pages", %{conn: conn} do
      insert_list(50, :player)
      {:ok, live, _} = live(conn, @players_path)

      assert {:ok, first_page_fragment} =
               live
               |> render()
               |> Floki.parse_fragment()

      first_page_information_text =
        first_page_fragment
        |> Floki.find("nav div p")
        |> List.first()
        |> Floki.text()
        |> trim_multiline_content()

      assert first_page_information_text =~ "Showing 1 to 30 of 50 results"

      _next_page_click =
        live
        |> element("nav section a:last-child")
        |> render_click()

      assert {:ok, next_page_fragment} =
               live
               |> render()
               |> Floki.parse_fragment()

      next_page_information_text =
        next_page_fragment
        |> Floki.find("nav div p")
        |> List.first()
        |> Floki.text()
        |> trim_multiline_content()

      assert next_page_information_text =~ "Showing 31 to 50 of 50 results"

      _previous_page_click =
        live
        |> element("nav section a:first-child")
        |> render_click()

      assert {:ok, previous_page_fragment} =
               live
               |> render()
               |> Floki.parse_fragment()

      previous_page_information_text =
        previous_page_fragment
        |> Floki.find("nav div p")
        |> List.first()
        |> Floki.text()
        |> trim_multiline_content()

      assert previous_page_information_text =~ "Showing 1 to 30 of 50 results"
    end

    test "do nothing when trying to navigate to negative pages", %{conn: conn} do
      insert_list(5, :player)
      {:ok, live, _} = live(conn, @players_path)

      assert {:ok, first_page_fragment} =
               live
               |> render()
               |> Floki.parse_fragment()

      first_page_information_text =
        first_page_fragment
        |> Floki.find("nav div p")
        |> List.first()
        |> Floki.text()
        |> trim_multiline_content()

      assert first_page_information_text =~ "Showing 1 to 5 of 5 results"

      _previous_page_click =
        live
        |> element("nav section a:first-child")
        |> render_click()

      assert {:ok, previous_page_fragment} =
               live
               |> render()
               |> Floki.parse_fragment()

      previous_page_information_text =
        previous_page_fragment
        |> Floki.find("nav div p")
        |> List.first()
        |> Floki.text()
        |> trim_multiline_content()

      assert previous_page_information_text =~ "Showing 1 to 5 of 5 results"
    end

    test "do nothing when trying to navigate to out of bound pages", %{conn: conn} do
      insert_list(5, :player)
      {:ok, live, _} = live(conn, @players_path)

      assert {:ok, first_page_fragment} =
               live
               |> render()
               |> Floki.parse_fragment()

      first_page_information_text =
        first_page_fragment
        |> Floki.find("nav div p")
        |> List.first()
        |> Floki.text()
        |> trim_multiline_content()

      assert first_page_information_text =~ "Showing 1 to 5 of 5 results"

      _next_page_click =
        live
        |> element("nav section a:last-child")
        |> render_click()

      assert {:ok, next_page_fragment} =
               live
               |> render()
               |> Floki.parse_fragment()

      next_page_information_text =
        next_page_fragment
        |> Floki.find("nav div p")
        |> List.first()
        |> Floki.text()
        |> trim_multiline_content()

      assert next_page_information_text =~ "Showing 1 to 5 of 5 results"
    end

    defp trim_multiline_content(content) do
      content
      |> String.trim()
      |> String.split(" ", trim: true)
      |> Enum.map(&String.trim/1)
      |> Enum.join(" ")
    end
  end

  describe "export" do
    test "shows export button", %{conn: conn} do
      {:ok, live, _} = live(conn, @players_path)

      {:ok, live_fragment} =
        live
        |> render()
        |> Floki.parse_fragment()

      csv_download_path =
        Routes.player_path(conn, :index, page: 1, page_size: 30, q: nil, sort: nil)

      assert [export_button] = Floki.find(live_fragment, "a#export")
      assert [csv_download_path] == Floki.attribute(export_button, "href")
      assert ["_blank"] == Floki.attribute(export_button, "target")
      assert ["Export to CSV"] == Floki.attribute(export_button, "title")
    end
  end
end
