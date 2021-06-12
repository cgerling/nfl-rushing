defmodule NflRushing.Repo.Migrations.CreatePlayerTable do
  use Ecto.Migration

  def change do
    create table("players", primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :position, :string, null: false

      timestamps()
    end
  end
end
