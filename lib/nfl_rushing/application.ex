defmodule NflRushing.Application do
  use Application

  @spec start(Application.start_type(), term) ::
          {:ok, pid} | {:ok, pid, Application.state()} | {:error, term}
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

  @spec config_change(keyword, keyword, [atom]) :: :ok
  def config_change(changed, _new, removed) do
    NflRushingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
