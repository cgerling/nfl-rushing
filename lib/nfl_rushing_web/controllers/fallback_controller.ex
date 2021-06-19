defmodule NflRushingWeb.FallbackController do
  use NflRushingWeb, :controller

  alias Ecto.Changeset
  alias NflRushingWeb.ChangesetView
  alias Plug.Conn

  @spec call(Conn.t(), term) :: Conn.t()
  def call(conn, {:error, %Changeset{} = changeset}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ChangesetView)
    |> render("error.json", changeset: changeset)
  end
end
