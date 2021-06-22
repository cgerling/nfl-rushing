defmodule NflRushing.Repo.Migrations.FixTypoInPlayerStatisticTable do
  use Ecto.Migration

  def change do
    rename table("player_statistics"), :total_rushing_touchdows, to: :total_rushing_touchdowns
  end
end
