defmodule NflRushingWeb.PlayerController do
  use NflRushingWeb, :controller

  alias NflRushing.League
  alias NflRushingWeb.PageObject
  alias NflRushingWeb.SearchObject
  alias NflRushingWeb.SortObject

  action_fallback(NflRushingWeb.FallbackController)

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, params) do
    sort_fields = [:total_rushing_yards, :longest_rush, :total_rushing_touchdowns]

    with {:ok, %PageObject{} = page_object} <- PageObject.from_params(params),
         {:ok, %SearchObject{} = search_object} <- SearchObject.from_params(params),
         {:ok, %SortObject{} = sort_object} <-
           SortObject.from_params(params, allowed_fields: sort_fields) do
      options = %{
        page: page_object,
        search: search_object,
        sort: sort_object
      }

      csv = League.export_players(options)

      filename = "rushing.csv"

      conn
      |> put_status(:ok)
      |> send_download({:binary, csv},
        charset: "utf-8",
        content_type: "text/csv",
        disposition: :attachment,
        filename: filename
      )
    end
  end
end
