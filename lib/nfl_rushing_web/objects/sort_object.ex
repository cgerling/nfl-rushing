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

  @spec changeset(%__MODULE__{}, map, Keyword.t()) :: Changeset.t()
  def changeset(%__MODULE__{} = struct, %{} = params, opts \\ []) do
    allowed_fields = Keyword.get(opts, :allowed_fields, [])

    struct
    |> cast(params, @fields)
    |> validate_format(:sort, @sort_expression_format)
    |> put_field_and_direction()
    |> validate_inclusion(:direction, @directions)
    |> validate_field_is_allowed(allowed_fields)
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

  defp validate_field_is_allowed(%Changeset{} = changeset, []),
    do: changeset

  defp validate_field_is_allowed(%Changeset{} = changeset, allowed_fields)
       when is_list(allowed_fields) do
    allowed_fields_string = Enum.map(allowed_fields, &Atom.to_string/1)

    changeset
    |> validate_inclusion(:field, allowed_fields_string)
    |> put_field_as_atom()
  end

  defp put_field_as_atom(%Changeset{valid?: true} = changeset) do
    field = get_change(changeset, :field)

    if is_binary(field) do
      field_atom = String.to_existing_atom(field)

      put_change(changeset, :field, field_atom)
    else
      changeset
    end
  end

  defp put_field_as_atom(%Changeset{} = changeset), do: changeset

  @spec from_params(map, Keyword.t()) :: {:ok, t()} | {:error, Changeset.t()}
  def from_params(params, opts \\ []) do
    %__MODULE__{}
    |> changeset(params, opts)
    |> apply_action(:parse)
  end

  @spec directions() :: list(atom)
  def directions do
    @directions
  end
end
