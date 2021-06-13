defmodule NflRushingWeb.SortObject do
  use NflRushingWeb, :object

  @type t :: %__MODULE__{
          direction: :asc | :desc,
          field: atom,
          sort: String.t()
        }

  @fields [:sort]

  @sort_expression_format ~r/(\w+):(\w+)/
  @directions [:asc, :desc]

  embedded_schema do
    field :direction, :string
    field :field, :string
    field :sort, :string, virtual: true
  end

  @spec changeset(%__MODULE__{}, map) :: Changeset.t()
  def changeset(%__MODULE__{} = struct, %{} = params) do
    struct
    |> cast(params, @fields)
    |> validate_format(:sort, @sort_expression_format)
    |> put_field_and_direction()
    |> validate_inclusion(:direction, @directions)
  end

  defp put_field_and_direction(%Changeset{valid?: true} = changeset) do
    changeset
    |> get_change(:sort)
    |> parse_sort_expression()
    |> case do
      [field, direction] ->
        direction = convert_direction(direction)

        changeset
        |> put_change(:direction, direction)
        |> put_change(:field, field)

      _ ->
        changeset
    end
  end

  defp put_field_and_direction(%Changeset{} = changeset),
    do: changeset

  defp parse_sort_expression(expression) when is_binary(expression),
    do: String.split(expression, ":")

  defp parse_sort_expression(_), do: nil

  defp convert_direction("asc"), do: :asc
  defp convert_direction("desc"), do: :desc
  defp convert_direction(direction), do: direction

  @spec from_params(map) :: {:ok, t()} | {:error, Changeset.t()}
  def from_params(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action(:parse)
  end

  @spec directions() :: list(atom)
  def directions do
    @directions
  end
end
