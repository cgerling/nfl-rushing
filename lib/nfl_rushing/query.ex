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

  @spec sort_by(Queryable.t(), atom | nil, atom | nil) :: Queryable.t()
  def sort_by(queryable, field, direction) when is_nil(field) or is_nil(direction),
    do: queryable

  def sort_by(queryable, field, direction) when is_atom(field) and is_atom(direction),
    do: order_by(queryable, ^[{direction, field}])

  @spec contains(Queryable.t(), atom, term) :: Queryable.t()
  def contains(queryable, field, nil) when is_atom(field),
    do: queryable

  def contains(queryable, field, value) when is_atom(field) do
    like_expression = "%#{value}%"

    from(element in queryable, where: like(field(element, ^field), ^like_expression))
  end

  @spec join_with(Queryable.t(), atom, atom) :: Queryable.t()
  def join_with(queryable, qualifier \\ :inner, association_name)
      when is_atom(qualifier) and is_atom(association_name) do
    queryable
    |> has_named_binding?(association_name)
    |> if(
      do: queryable,
      else: join_with_association(queryable, qualifier, association_name)
    )
  end

  defp join_with_association(queryable, qualifier, association_name)
       when is_atom(qualifier) and is_atom(association_name) do
    queryable
    |> join(qualifier, [element], assoc(element, ^association_name))
    |> put_dynamic_alias()
  end

  defp put_dynamic_alias(%Ecto.Query{aliases: aliases, joins: joins} = query) do
    last_join = Enum.at(joins, -1)
    {_, association_name} = last_join.assoc

    aliased_join = %{last_join | as: association_name}
    joins_with_aliased_join = List.replace_at(joins, -1, aliased_join)

    alias_index = Enum.count(joins)
    aliases = Map.put(aliases, association_name, alias_index)

    query
    |> Map.put(:joins, joins_with_aliased_join)
    |> Map.put(:aliases, aliases)
  end
end
