defmodule NflRushingWeb.PlayerController do
  use NflRushingWeb, :controller

  alias NflRushing.League

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, params) do
    players =
      params
      |> get_pagination_params()
      |> League.list_players()

    conn
    |> put_status(:ok)
    |> render("index.json", players: players)
  end

  defp get_pagination_params(%{"page" => page, "page_size" => page_size}) do
    %{
      page: String.to_integer(page),
      page_size: String.to_integer(page_size)
    }
  end

  defp get_pagination_params(%{"page" => page}) do
    %{
      page: String.to_integer(page)
    }
  end

  defp get_pagination_params(%{"page_size" => page_size}) do
    %{
      page_size: String.to_integer(page_size)
    }
  end

  defp get_pagination_params(%{}) do
    %{}
  end
end
