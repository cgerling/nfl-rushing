defmodule NflRushing.Repo.Migrations.CreateTeamsTable do
  use Ecto.Migration

  def change do
    create table("teams", primary_key: false) do
      add :abbreviation, :string, null: false
      add :id, :binary_id, primary_key: true

      timestamps()
    end
  end
end
