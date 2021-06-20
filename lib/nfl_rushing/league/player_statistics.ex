defmodule NflRushing.League.PlayerStatistic do
  use NflRushing.Schema

  alias NflRushing.League.Player

  @type t :: %__MODULE__{
          average_rushing_attempts_per_game: float,
          average_rushing_yards_per_attempt: float,
          inserted_at: NaiveDateTime.t() | nil,
          longest_rush: integer,
          player: Player.t(),
          rushing_attempts: integer,
          rushing_first_downs: integer,
          rushing_first_downs_percentage: float,
          rushing_fourty_yards_each: integer,
          rushing_fumbles: integer,
          rushing_twenty_yards_each: integer,
          rushing_yards_per_game: float,
          total_rushing_touchdowns: integer,
          total_rushing_yards: integer,
          updated_at: NaiveDateTime.t() | nil
        }

  @required_fields [
    :average_rushing_attempts_per_game,
    :average_rushing_yards_per_attempt,
    :longest_rush,
    :rushing_attempts,
    :rushing_first_downs,
    :rushing_first_downs_percentage,
    :rushing_fourty_yards_each,
    :rushing_fumbles,
    :rushing_twenty_yards_each,
    :rushing_yards_per_game,
    :total_rushing_touchdowns,
    :total_rushing_yards
  ]
  @fields @required_fields

  schema "player_statistics" do
    field :average_rushing_attempts_per_game, :float
    field :average_rushing_yards_per_attempt, :float
    field :longest_rush, :integer
    field :rushing_attempts, :integer
    field :rushing_first_downs, :integer
    field :rushing_first_downs_percentage, :float
    field :rushing_fourty_yards_each, :integer
    field :rushing_fumbles, :integer
    field :rushing_twenty_yards_each, :integer
    field :rushing_yards_per_game, :float
    field :total_rushing_touchdowns, :integer
    field :total_rushing_yards, :integer

    timestamps()

    belongs_to :player, Player
  end

  @spec changeset(%__MODULE__{}, map) :: Changeset.t()
  def changeset(%__MODULE__{} = struct, %{} = params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:player)
  end
end
