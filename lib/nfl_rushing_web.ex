defmodule NflRushingWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use NflRushingWeb, :controller
      use NflRushingWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  @spec controller() :: term
  def controller do
    quote do
      use Phoenix.Controller, namespace: NflRushingWeb

      import Plug.Conn
      alias NflRushingWeb.Router.Helpers, as: Routes
    end
  end

  @spec view() :: term
  def view do
    quote do
      use Phoenix.View,
        root: "lib/nfl_rushing_web/templates",
        namespace: NflRushingWeb

      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      unquote(view_helpers())
    end
  end

  @spec router() :: term
  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
    end
  end

  @spec channel() :: term
  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  defp view_helpers do
    quote do
      import Phoenix.View

      import NflRushingWeb.ErrorHelpers
      alias NflRushingWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end