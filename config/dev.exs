import Config

config :logger, :console, format: "[$level] $message\n"

config :nfl_rushing, NflRushing.Repo,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :nfl_rushing, NflRushingWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

config :nfl_rushing, NflRushingWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"lib/nfl_rushing_web/(live|views)/.*(ex)$",
      ~r"lib/nfl_rushing_web/templates/.*(eex)$"
    ]
  ]

config :phoenix,
  plug_init_mode: :runtime,
  stacktrace_depth: 20
