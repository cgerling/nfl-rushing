import Config

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  config :nfl_rushing, NflRushing.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  hostname =
    System.get_env("HOSTNAME") ||
      raise """
      environment variable HOSTNAME is missing.
      For example: example.com
      """

  port = String.to_integer(System.get_env("PORT") || "4000")

  config :nfl_rushing, NflRushingWeb.Endpoint,
    http: [
      port: port,
      transport_options: [socket_opts: [:inet6]]
    ],
    secret_key_base: secret_key_base,
    url: [host: hostname, port: port]
end
