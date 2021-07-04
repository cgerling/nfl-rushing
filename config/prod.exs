import Config

config :nfl_rushing, NflRushingWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json"

config :nfl_rushing, NflRushing.Repo, ssl: true
