defmodule NflRushingWeb.Router do
  use NflRushingWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {NflRushingWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NflRushingWeb do
    pipe_through :browser

    live "/", PlayersLive, :index
  end

  scope "/api", NflRushingWeb do
    pipe_through :api

    resources "/players", PlayerController, only: [:index]
    resources "/health", HealthController, only: [:index]
  end
end
