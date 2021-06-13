defmodule NflRushingWeb.PlayerController do
  use NflRushingWeb, :controller

  alias NflRushing.League
  alias NflRushingWeb.PageObject
  alias NflRushingWeb.SearchObject

  action_fallback(NflRushingWeb.FallbackController)

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, params) do
    with {:ok, page_object} <- PageObject.from_params(params),
         {:ok, search_object} <- SearchObject.from_params(params) do
      players =
        page_object
        |> merge_objects(search_object)
        |> League.list_players()

      conn
      |> put_status(:ok)
      |> render("index.json", players: players)
    end
  end

  defp merge_objects(object_a, object_b) do
    object_a_map = Map.from_struct(object_a)
    object_b_map = Map.from_struct(object_b)

    Map.merge(object_a_map, object_b_map)
  end
end
