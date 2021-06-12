defmodule NflRushingWeb.HealthControllerTest do
  use NflRushingWeb.ConnCase, async: true

  describe "GET /health" do
    test "returns ok with empty body", %{conn: conn} do
      assert response =
               conn
               |> get(Routes.health_path(conn, :index))
               |> response(:ok)

      assert response == ""
    end
  end
end
