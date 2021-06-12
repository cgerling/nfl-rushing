defmodule NflRushing.Repo.Migrations.CreatePlayerStatisticsTable do
  use Ecto.Migration

  def change do
    create table("player_statistics", primary_key: false) do
      add :average_rushing_attempts_per_game, :float, null: false
      add :average_rushing_yards_per_attempt, :float, null: false
      add :id, :binary_id, primary_key: true
      add :longest_rush, :integer, null: false
      add :player_id, references("players", type: :binary_id), null: false
      add :rushing_attempts, :integer, null: false
      add :rushing_first_downs, :integer, null: false
      add :rushing_first_downs_percentage, :float, null: false
      add :rushing_fourty_yards_each, :integer, null: false
      add :rushing_fumbles, :integer, null: false
      add :rushing_twenty_yards_each, :integer, null: false
      add :rushing_yards_per_game, :float, null: false
      add :total_rushing_touchdows, :integer, null: false
      add :total_rushing_yards, :integer, null: false

      timestamps()
    end
  end
end
