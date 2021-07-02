defmodule NflRushingWeb.PlayerController do
  use NflRushingWeb, :controller

  alias NflRushing.League
  alias NflRushingWeb.ListPlayersObject

  action_fallback(NflRushingWeb.FallbackController)

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, params) do
    with {:ok, %ListPlayersObject{} = list_players_object} <-
           ListPlayersObject.from_params(params) do
      %{entries: players} = League.list_players(list_players_object)

      conn
      |> put_status(:ok)
      |> render("index.json", players: players)
    end
  end
end
