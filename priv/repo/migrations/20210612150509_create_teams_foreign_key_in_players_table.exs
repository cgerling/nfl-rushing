defmodule NflRushing.Repo.Migrations.CreateTeamsForeignKeyInPlayersTable do
  use Ecto.Migration

  def change do
    alter table("players") do
      add :team_id, references("teams", type: :binary_id), null: false
    end
  end
end
