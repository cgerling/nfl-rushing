defmodule NflRushingWeb.SortObjectTest do
  use ExUnit.Case, async: true

  import NflRushing.DataHelper

  alias Ecto.Changeset
  alias NflRushingWeb.SortObject

  describe "changeset/2" do
    @valid_params %{
      sort: "field:asc"
    }

    test "returns a valid changeset when params are valid" do
      changeset = SortObject.changeset(%SortObject{}, @valid_params)

      assert %Changeset{valid?: true} = changeset
    end

    test "returns a valid changeset when params are empty" do
      empty_params = %{}
      changeset = SortObject.changeset(%SortObject{}, empty_params)

      assert %Changeset{valid?: true} = changeset
    end

    test "returns an invalid changeset when direction param is not valid" do
      invalid_direction = "invalid_direction"
      invalid_params = %{sort: "field:#{invalid_direction}"}
      changeset = SortObject.changeset(%SortObject{}, invalid_params)

      assert %Changeset{valid?: false} = changeset
      assert errors_on(changeset) == %{direction: ["is invalid"]}
    end

    test "returns an invalid changeset when sort params does not specify a direction" do
      no_direction_sort = "field:"
      invalid_params = %{sort: no_direction_sort}
      changeset = SortObject.changeset(%SortObject{}, invalid_params)

      assert %Changeset{valid?: false} = changeset
      assert errors_on(changeset) == %{sort: ["has invalid format"]}
    end

    test "returns an invalid changeset when sort params does not specify a field" do
      no_field_sort = ":asc"
      invalid_params = %{sort: no_field_sort}
      changeset = SortObject.changeset(%SortObject{}, invalid_params)

      assert %Changeset{valid?: false} = changeset
      assert errors_on(changeset) == %{sort: ["has invalid format"]}
    end

    test "returns an invalid changeset when direction is not valid" do
      invalid_direction_sort = "field:invalid"
      invalid_direction_params = %{sort: invalid_direction_sort}
      changeset = SortObject.changeset(%SortObject{}, invalid_direction_params)

      assert %Changeset{valid?: false} = changeset

      assert changeset.errors == [
               direction: {"is invalid", [validation: :inclusion, enum: [:asc, :desc]]}
             ]
    end
  end

  describe "from_params/1" do
    test "returns a ok with a struct containing the informed values when params are valid" do
      field = "field"
      direction = :asc
      sort = "#{field}:#{direction}"
      params = %{"sort" => sort}

      assert {:ok, sort_object} = SortObject.from_params(params)

      assert sort_object.field == field
      assert sort_object.direction == direction
      assert sort_object.sort == sort
    end

    test "returns a ok with a struct containing the default values when params are empty" do
      empty_params = %{}

      assert {:ok, sort_object} = SortObject.from_params(empty_params)

      assert is_nil(sort_object.field)
      assert is_nil(sort_object.field)
      assert is_nil(sort_object.field)
    end

    test "returns an error with an invalid changeset when params are invalid" do
      invalid_params = %{"sort" => "invalid"}

      assert {:error, changeset} = SortObject.from_params(invalid_params)

      assert %Changeset{valid?: false} = changeset
      assert errors_on(changeset) == %{sort: ["has invalid format"]}
    end
  end

  describe "directions/0" do
    test "return a list with the supported directions" do
      assert SortObject.directions() == [:asc, :desc]
    end
  end
end
