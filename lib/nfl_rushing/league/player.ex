defmodule NflRushing.League.Player do
  use NflRushing.Schema

  alias NflRushing.League.PlayerStatistic
  alias NflRushing.League.Team

  @type t :: %__MODULE__{
          id: String.t() | nil,
          name: String.t(),
          position: String.t(),
          team: %Team{} | Ecto.Association.NotLoaded.t() | nil,
          inserted_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  @required_fields [:name, :position, :team_id]
  @fields @required_fields

  schema "players" do
    field :name, :string
    field :position, :string

    timestamps()

    belongs_to :team, Team
    has_one :statistic, PlayerStatistic
  end

  @spec changeset(%__MODULE__{}, map) :: Changeset.t()
  def changeset(%__MODULE__{} = struct, %{} = params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:team)
  end

  @spec import_changeset(map) :: Changeset.t()
  def import_changeset(%{} = params) do
    %__MODULE__{}
    |> changeset(params)
    |> cast_assoc(:statistic, with: &PlayerStatistic.changeset/2)
  end
end
