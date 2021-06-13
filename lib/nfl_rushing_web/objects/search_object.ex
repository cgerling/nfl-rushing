defmodule NflRushingWeb.SearchObject do
  use NflRushingWeb, :object

  @type t :: %__MODULE__{
          q: String.t() | nil
        }

  @fields [:q]

  @only_safe_characters ~r/[^%_]/

  embedded_schema do
    field :q, :string
  end

  @spec changeset(%__MODULE__{}, map) :: Changeset.t()
  def changeset(%__MODULE__{} = struct, %{} = params) do
    struct
    |> cast(params, @fields)
    |> validate_format(:q, @only_safe_characters, message: "can't contain unsafe characters")
  end

  @spec from_params(map) :: {:ok, t()} | {:error, Changeset.t()}
  def from_params(%{} = params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action(:parse)
  end
end
