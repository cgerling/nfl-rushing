defmodule NflRushingWeb.PlayerController do
  use NflRushingWeb, :controller

  alias NflRushing.League
  alias NflRushingWeb.PageObject

  action_fallback(NflRushingWeb.FallbackController)

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, params) do
    with {:ok, page_object} <- PageObject.from_params(params) do
      players = League.list_players(page_object)

      conn
      |> put_status(:ok)
      |> render("index.json", players: players)
    end
  end
end
