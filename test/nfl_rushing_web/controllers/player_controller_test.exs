defmodule NflRushingWeb.PlayerControllerTest do
  use NflRushingWeb.ConnCase, async: true

  describe "GET /players" do
    test "returns a list with all players", %{conn: conn} do
      insert_list(5, :player)

      assert response =
               conn
               |> get(Routes.player_path(conn, :index))
               |> json_response(:ok)

      assert %{"data" => players} = response
      assert Enum.count(players) == 5

      assert Enum.all?(
               players,
               &match?(%{"name" => _, "position" => _, "statistic" => _, "team" => _}, &1)
             )
    end
  end
end
