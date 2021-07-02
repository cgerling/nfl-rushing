defmodule NflRushingWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use NflRushingWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      import Plug.Conn
      import Phoenix.ConnTest
      import NflRushing.DataHelper
      import NflRushing.Factory
      import NflRushingWeb.ConnCase

      alias NflRushingWeb.Router.Helpers, as: Routes

      @endpoint NflRushingWeb.Endpoint
    end
  end

  setup tags do
    :ok = Sandbox.checkout(NflRushing.Repo)

    unless tags[:async] do
      Sandbox.mode(NflRushing.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
