defmodule NflRushingWeb.PlayerControllerTest do
  use NflRushingWeb.ConnCase, async: true

  alias Plug.Conn

  describe "GET /players" do
    test "returns a csv file attachment as response", %{conn: conn} do
      conn = get(conn, Routes.player_path(conn, :index))

      content_type = response_content_type(conn, :csv)
      assert content_type =~ "charset=utf-8"

      content_disposition = conn |> Conn.get_resp_header("content-disposition") |> List.first()
      assert content_disposition == ~s{attachment; filename="rushing.csv"}
    end

    test "returns a csv file with the default amount of players", %{conn: conn} do
      players = insert_list(40, :player)

      assert response =
               conn
               |> get(Routes.player_path(conn, :index))
               |> response(:ok)

      csv =
        players
        |> Enum.sort_by(& &1.id, :asc)
        |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})
        |> Enum.take(30)
        |> build_csv()

      assert csv == response
    end

    test "returns a csv file with a subset of players when page query parameter is passed", %{
      conn: conn
    } do
      players = insert_list(40, :player)

      assert response =
               conn
               |> get(Routes.player_path(conn, :index), page: 2)
               |> response(:ok)

      csv =
        players
        |> Enum.sort_by(& &1.id, :asc)
        |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})
        |> Enum.drop(30)
        |> build_csv()

      assert csv == response
    end

    test "returns a csv file with a custom amount of players when page size query parameter is passed",
         %{conn: conn} do
      players = insert_list(10, :player)

      assert response =
               conn
               |> get(Routes.player_path(conn, :index), page_size: 5)
               |> response(:ok)

      csv =
        players
        |> Enum.sort_by(& &1.id, :asc)
        |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})
        |> Enum.take(5)
        |> build_csv()

      assert csv == response
    end

    test "returns a csv file with players filtered by name when q query parameter is passed", %{
      conn: conn
    } do
      _players = insert_list(10, :player)
      named_player = insert(:player)

      assert response =
               conn
               |> get(Routes.player_path(conn, :index), q: named_player.name)
               |> response(:ok)

      csv = build_csv([named_player])

      assert csv == response
    end

    test "returns a csv file with players in custom order when sort query parameter is passed", %{
      conn: conn
    } do
      players = insert_list(10, :player)

      sort = "longest_rush:desc"

      assert response =
               conn
               |> get(Routes.player_path(conn, :index, sort: sort))
               |> response(:ok)

      csv =
        players
        |> Enum.sort_by(& &1.id, :asc)
        |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})
        |> Enum.sort_by(& &1.statistic.longest_rush, :desc)
        |> build_csv()

      assert csv == response
    end

    test "returns a csv file empty when no player was found", %{conn: conn} do
      assert response =
               conn
               |> get(Routes.player_path(conn, :index))
               |> response(:ok)

      csv = build_csv([])

      assert csv == response
    end

    test "returns bad request when invalid page query parameters is informed", %{conn: conn} do
      params = %{"page" => -1, "page_size" => -1}

      assert response =
               conn
               |> get(Routes.player_path(conn, :index, params))
               |> json_response(:bad_request)

      assert response == %{
               "errors" => %{
                 "page" => ["must be greater than 0"],
                 "page_size" => ["must be greater than 0"]
               }
             }
    end

    test "returns bad request when invalid search query parameter is informed", %{conn: conn} do
      params = %{"page" => 1, "page_size" => 1, "q" => "%_"}

      assert response =
               conn
               |> get(Routes.player_path(conn, :index, params))
               |> json_response(:bad_request)

      assert response == %{
               "errors" => %{
                 "q" => ["can't contain unsafe characters"]
               }
             }
    end

    test "returns bad request when invalid sort query parameter is informed", %{conn: conn} do
      params = %{"page" => 1, "page_size" => 1, "q" => "", "sort" => "field:direction"}

      assert response =
               conn
               |> get(Routes.player_path(conn, :index, params))
               |> json_response(:bad_request)

      assert response == %{
               "errors" => %{
                 "direction" => ["is invalid"],
                 "field" => ["is invalid"]
               }
             }
    end
  end
end
