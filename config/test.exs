import Config

config :nfl_rushing, NflRushing.Repo,
  username: "postgres",
  password: "postgres",
  database: "nfl_rushing_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :nfl_rushing, NflRushingWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
