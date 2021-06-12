defmodule NflRushing.League.Team do
  use NflRushing.Schema

  @type t :: %__MODULE__{
          abbreviation: String.t(),
          inserted_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  @required_fields [:abbreviation]
  @fields @required_fields

  schema "teams" do
    field :abbreviation, :string

    timestamps()
  end

  @spec changeset(%__MODULE__{}, map) :: Changeset.t()
  def changeset(%__MODULE__{} = struct, %{} = params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@required_fields)
  end
end
