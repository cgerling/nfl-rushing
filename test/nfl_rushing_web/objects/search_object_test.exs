defmodule NflRushingWeb.SearchObjectTest do
  use ExUnit.Case, async: true

  import NflRushing.DataHelper

  alias Ecto.Changeset
  alias NflRushingWeb.SearchObject

  describe "changeset/2" do
    @valid_params %{
      q: Faker.Lorem.word()
    }

    test "returns a valid changeset when params are valid" do
      changeset = SearchObject.changeset(%SearchObject{}, @valid_params)

      assert %Changeset{valid?: true} = changeset
    end

    test "returns a valid changeset with default values when params are empty" do
      empty_params = %{}
      changeset = SearchObject.changeset(%SearchObject{}, empty_params)

      assert %Changeset{valid?: true} = changeset
      assert changeset |> Changeset.get_field(:q) |> is_nil()
    end

    test "returns an invalid changeset when q param contains unsafe characters" do
      unsafe_characters = ["%", "_"]

      for unsafe_character <- unsafe_characters do
        unsafe_params = %{q: unsafe_character}
        changeset = SearchObject.changeset(%SearchObject{}, unsafe_params)

        assert %Changeset{valid?: false} = changeset
        assert errors_on(changeset) == %{q: ["can't contain unsafe characters"]}
      end
    end
  end

  describe "from_params/1" do
    test "returns a ok with a struct containing the informed values when params are valid" do
      q = Faker.Lorem.word()
      params = %{q: q}

      assert {:ok, %SearchObject{} = search_object} = SearchObject.from_params(params)

      assert search_object.q == q
    end

    test "returns a ok with a struct containing the default values when params are empty" do
      empty_params = %{}

      assert {:ok, %SearchObject{} = search_object} = SearchObject.from_params(empty_params)

      assert is_nil(search_object.q)
    end

    test "returns an error with an invalid changeset when params contains unsafe characters" do
      unsafe_params = %{q: "%"}

      assert {:error, changeset} = SearchObject.from_params(unsafe_params)

      assert %Changeset{valid?: false} = changeset
      assert errors_on(changeset) == %{q: ["can't contain unsafe characters"]}
    end
  end
end
