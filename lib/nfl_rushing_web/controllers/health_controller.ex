defmodule NflRushingWeb.HealthController do
  use NflRushingWeb, :controller

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, _params) do
    send_resp(conn, :ok, "")
  end
end
