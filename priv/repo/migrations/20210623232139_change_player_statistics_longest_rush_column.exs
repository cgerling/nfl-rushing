defmodule NflRushing.Repo.Migrations.ChangePlayerStatisticsLongestRushColumn do
  use Ecto.Migration

  def change do
    alter table(:player_statistics) do
      modify :longest_rush, :string, null: false
    end
  end
end
