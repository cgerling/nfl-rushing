defmodule NflRushingWeb.PageObject do
  use NflRushingWeb, :object

  @type t :: %__MODULE__{
          page: non_neg_integer,
          page_size: non_neg_integer
        }

  @fields [:page, :page_size]

  embedded_schema do
    field :page, :integer, default: 1
    field :page_size, :integer, default: 30
  end

  @spec changeset(%__MODULE__{}, map) :: Changeset.t()
  def changeset(%__MODULE__{} = struct, %{} = params) do
    struct
    |> cast(params, @fields)
    |> validate_number(:page, greater_than: 0)
    |> validate_number(:page_size, greater_than: 0)
  end

  @spec from_params(map) :: {:ok, t()} | {:error, Changeset.t()}
  def from_params(%{} = params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action(:parse)
  end
end
