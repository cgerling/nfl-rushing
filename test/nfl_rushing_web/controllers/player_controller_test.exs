defmodule NflRushingWeb.PlayerControllerTest do
  use NflRushingWeb.ConnCase, async: true

  describe "GET /players" do
    test "returns a list of players with statistic and team information", %{conn: conn} do
      insert_list(5, :player)

      assert response =
               conn
               |> get(Routes.player_path(conn, :index))
               |> json_response(:ok)

      assert %{"data" => players} = response

      assert Enum.all?(
               players,
               &match?(%{"name" => _, "position" => _, "statistic" => _, "team" => _}, &1)
             )
    end

    test "returns a page of players with default size", %{conn: conn} do
      insert_list(50, :player)

      assert response =
               conn
               |> get(Routes.player_path(conn, :index))
               |> json_response(:ok)

      %{"data" => players} = response
      assert Enum.count(players) == 30
    end

    test "returns a page of players with a custom size", %{conn: conn} do
      insert_list(50, :player)

      params = %{"page_size" => 50}

      assert response =
               conn
               |> get(Routes.player_path(conn, :index, params))
               |> json_response(:ok)

      %{"data" => players} = response
      assert Enum.count(players) == 50
    end

    test "returns an empty list of players when no player was found", %{conn: conn} do
      assert response =
               conn
               |> get(Routes.player_path(conn, :index))
               |> json_response(:ok)

      %{"data" => players} = response
      assert Enum.empty?(players)
    end
  end
end
