defmodule NflRushingWeb.PlayerController do
  use NflRushingWeb, :controller

  alias NflRushing.League

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, _) do
    players = League.list_players()

    conn
    |> put_status(:ok)
    |> render("index.json", players: players)
  end
end
