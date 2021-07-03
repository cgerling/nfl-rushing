defmodule NflRushing.ReleaseTasks do
  @otp_app_dependencies [
    :crypto,
    :ssl,
    :postgrex,
    :ecto,
    :ecto_sql,
    :logger
  ]

  alias Ecto.Adapters.Postgres
  alias Ecto.Migrator
  alias NflRushing.Repo

  require Logger

  @otp_app :nfl_rushing
  @logger_application :logger

  @spec setup() :: no_return()
  def setup do
    start(:logger)

    Logger.info("=> Starting Application")
    start(:application)

    Logger.info("=> Starting Dependencies")
    start(:dependencies)

    Logger.info("=> Creating Database")
    create_database()

    Logger.info("=> Connecting to Database")
    start(:database)

    Logger.info("=> Running Migrations")
    run_migrations()

    Logger.info("=> Setup Completed")
  end

  defp start(:logger),
    do: Application.ensure_started(@logger_application)

  defp start(:application),
    do: Application.load(@otp_app)

  defp start(:dependencies) do
    Enum.each(@otp_app_dependencies, fn dependency ->
      Logger.info("  => Starting #{dependency}")
      result = Application.ensure_all_started(dependency)
      Logger.info("  => Completed #{dependency} - #{inspect(result)}")
    end)
  end

  defp start(:database),
    do: Repo.start_link()

  defp create_database,
    do: Repo.config() |> Postgres.storage_up()

  defp run_migrations do
    migrations_path = Migrator.migrations_path(Repo)

    Migrator.run(Repo, migrations_path, :up, all: true, log: :debug)
  end
end
