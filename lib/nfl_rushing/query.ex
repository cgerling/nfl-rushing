defmodule NflRushing.Query do
  import Ecto.Query

  alias Ecto.Queryable

  @spec limit_by(Queryable.t(), integer) :: Queryable.t()
  def limit_by(queryable, amount) when is_integer(amount),
    do: limit(queryable, ^amount)

  @spec offset_by(Queryable.t(), integer) :: Queryable.t()
  def offset_by(queryable, amount) when is_integer(amount),
    do: offset(queryable, ^amount)

  @spec paginate(Queryable.t(), list) :: Queryable.t()
  def paginate(queryable, opts \\ []) when is_list(opts) do
    page = Keyword.get(opts, :page)
    page_size = Keyword.get(opts, :page_size)

    offset_amount = (page - 1) * page_size

    queryable
    |> subquery()
    |> limit_by(page_size)
    |> offset_by(offset_amount)
  end

  @spec sort_by(Queryable.t(), atom, atom) :: Queryable.t()
  def sort_by(queryable, field, direction) when is_atom(field) and is_atom(direction),
    do: order_by(queryable, ^[{direction, field}])

  @spec contains(Queryable.t(), atom, term) :: Queryable.t()
  def contains(queryable, field, nil) when is_atom(field),
    do: queryable

  def contains(queryable, field, value) when is_atom(field) do
    like_expression = "%#{value}%"

    from(element in queryable, where: like(field(element, ^field), ^like_expression))
  end
end
