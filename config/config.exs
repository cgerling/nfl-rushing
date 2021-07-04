import Config

config :logger,
  backends: [:console],
  level: :info

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :nfl_rushing,
  ecto_repos: [NflRushing.Repo],
  generators: [binary_id: true]

config :nfl_rushing, NflRushingWeb.Endpoint,
  live_view: [signing_salt: "JBOoLGoz1/61SZNponcyDIeg2/VcmvHu"],
  pubsub_server: NflRushing.PubSub,
  render_errors: [view: NflRushingWeb.ErrorView, accepts: ~w(json), layout: false],
  secret_key_base: "fPOAHzp1BFVQbW/gfkH5k1WhIn1gX1oTRgWDxkNAEFuz+r2BKGfusIk4G4qkVJ4D",
  url: [host: "localhost"]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
