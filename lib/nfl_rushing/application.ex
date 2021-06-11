defmodule NflRushing.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      NflRushing.Repo,
      NflRushingWeb.Telemetry,
      {Phoenix.PubSub, name: NflRushing.PubSub},
      NflRushingWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: NflRushing.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    NflRushingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
