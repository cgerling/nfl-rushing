defmodule NflRushingWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :nfl_rushing

  @session_options [
    store: :cookie,
    key: "_nfl_rushing_key",
    signing_salt: "DP0vYzMP"
  ]

  plug Plug.Static,
    at: "/",
    from: :nfl_rushing,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :nfl_rushing
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug NflRushingWeb.Router
end
