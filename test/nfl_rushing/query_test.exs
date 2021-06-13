defmodule NflRushing.QueryTest do
  use ExUnit.Case, async: true

  alias NflRushing.Query

  defmodule TestSchema do
    use Ecto.Schema

    schema("test_schema", do: [])
  end

  describe "limit_by/2" do
    test "returns a queryable with a limit clause containing the given amount" do
      query = ~s{#Ecto.Query<from t0 in NflRushing.QueryTest.TestSchema, limit: ^1>}

      queryable = Query.limit_by(TestSchema, 1)

      assert query == inspect(queryable)
    end
  end

  describe "offset_by/2" do
    test "returns a queryable with a offset clause containing the given amount" do
      query = ~s{#Ecto.Query<from t0 in NflRushing.QueryTest.TestSchema, offset: ^1>}

      queryable = Query.offset_by(TestSchema, 1)

      assert query == inspect(queryable)
    end
  end

  describe "paginate/2" do
    test "returns a queryable with a subquery of the given queryable partitioned by a limit and offset clause" do
      query =
        ~s{#Ecto.Query<from t0 in subquery(from t0 in NflRushing.QueryTest.TestSchema), limit: ^30, offset: ^0>}

      queryable = Query.paginate(TestSchema, page: 1, page_size: 30)

      assert query == inspect(queryable)
    end
  end

  describe "sort_by/3" do
    test "returns a queryable with a order by clause of the given field and direction" do
      query =
        ~s{#Ecto.Query<from t0 in NflRushing.QueryTest.TestSchema, order_by: [asc: t0.field]>}

      queryable = Query.sort_by(TestSchema, :field, :asc)

      assert query == inspect(queryable)
    end
  end

  describe "contains/3" do
    test "returns a queryable with a like clause for the given value" do
      query =
        ~s{#Ecto.Query<from t0 in NflRushing.QueryTest.TestSchema, where: like(t0.field, ^"%value%")>}

      queryable = Query.contains(TestSchema, :field, "value")

      assert query == inspect(queryable)
    end

    test "returns a queryable unchanged when value is nil" do
      query = ~s{NflRushing.QueryTest.TestSchema}

      queryable = Query.contains(TestSchema, :field, nil)

      assert query == inspect(queryable)
    end
  end
end
