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

  describe "sort_by/4" do
    test "returns a queryable with a order by clause of the given field and direction" do
      query =
        ~s{#Ecto.Query<from t0 in NflRushing.QueryTest.TestSchema, order_by: [asc: t0.field]>}

      queryable = Query.sort_by(TestSchema, :field, :asc)

      assert query == inspect(queryable)
    end

    test "returns a queryable with a order by clause of the given field and direction of an association" do
      query =
        ~s{#Ecto.Query<from t0 in NflRushing.QueryTest.TestSchema, join: t1 in assoc(t0, :test_association), as: :test_association, order_by: [asc: t1.field]>}

      queryable =
        TestSchema
        |> Query.join_with(:test_association)
        |> Query.sort_by(:field, :asc, of: :test_association)

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

  describe "join_with/3" do
    test "returns a queryable with a named join clause when joining with an association" do
      query =
        ~s{#Ecto.Query<from t0 in NflRushing.QueryTest.TestSchema, join: t1 in assoc(t0, :test_association), as: :test_association>}

      queryable = Query.join_with(TestSchema, :test_association)

      assert query == inspect(queryable)
    end

    test "returns a queryable with a named join clause unchanged when joining with an association more than once" do
      query =
        ~s{#Ecto.Query<from t0 in NflRushing.QueryTest.TestSchema, join: t1 in assoc(t0, :test_association), as: :test_association>}

      queryable =
        TestSchema
        |> Query.join_with(:test_association)
        |> Query.join_with(:test_association)

      assert query == inspect(queryable)
    end

    test "returns a queryable with multiple named join clauses when joining with different associations" do
      query =
        ~s{#Ecto.Query<from t0 in NflRushing.QueryTest.TestSchema, join: t1 in assoc(t0, :test_association), as: :test_association, join: a2 in assoc(t0, :another_association), as: :another_association>}

      queryable =
        TestSchema
        |> Query.join_with(:test_association)
        |> Query.join_with(:another_association)

      assert query == inspect(queryable)
    end
  end
end
