defmodule NflRushingWeb.ListPlayersObjectTest do
  use ExUnit.Case, async: true

  import NflRushing.DataHelper

  alias Ecto.Changeset
  alias NflRushingWeb.ListPlayersObject
  alias NflRushingWeb.PageObject
  alias NflRushingWeb.SearchObject
  alias NflRushingWeb.SortObject

  describe "changeset/2" do
    @valid_params %{
      page: 1,
      page_size: 10,
      q: "search",
      sort: "longest_rush:asc"
    }

    test "returns a valid changeset when params are valid" do
      changeset = ListPlayersObject.changeset(%ListPlayersObject{}, @valid_params)

      assert %Changeset{valid?: true} = changeset
    end

    test "returns a valid changeset when params are empty" do
      empty_params = %{}
      changeset = ListPlayersObject.changeset(%ListPlayersObject{}, empty_params)

      assert %Changeset{valid?: true} = changeset
    end

    test "returns an invalid changeset when sort field is not allowed" do
      not_allowed_sort_params = %{@valid_params | sort: "field:asc"}
      changeset = ListPlayersObject.changeset(%ListPlayersObject{}, not_allowed_sort_params)

      assert %Changeset{valid?: false} = changeset
      assert errors_on(changeset) == %{sort: %{field: ["is invalid"]}}
    end

    test "returns an invalid changeset when params are not valid" do
      invalid_params = %{page: 0, page_size: 0, q: "%_", sort: "invalid_field:invalid_direction"}
      changeset = ListPlayersObject.changeset(%ListPlayersObject{}, invalid_params)

      assert %Changeset{valid?: false} = changeset

      assert errors_on(changeset) == %{
               page: %{page: ["must be greater than 0"], page_size: ["must be greater than 0"]},
               search: %{q: ["can't contain unsafe characters"]},
               sort: %{direction: ["is invalid"], field: ["is invalid"]}
             }
    end
  end

  describe "from_params/1" do
    test "returns ok with a struct containing the informed values when params are valid" do
      page = :rand.uniform(100)
      page_size = :rand.uniform(100)
      q = Faker.Lorem.word()
      field = ListPlayersObject.sort_fields() |> Enum.random()
      direction = SortObject.directions() |> Enum.random()
      sort = "#{field}:#{direction}"

      params = %{
        "page" => page,
        "page_size" => page_size,
        "q" => q,
        "sort" => sort
      }

      assert {:ok, %ListPlayersObject{} = list_players_object} =
               ListPlayersObject.from_params(params)

      assert list_players_object.page == %PageObject{page: page, page_size: page_size}
      assert list_players_object.search == %SearchObject{q: q}

      assert list_players_object.sort == %SortObject{
               field: field,
               direction: direction,
               sort: sort
             }
    end

    test "returns ok with a struct containing the informed values when params are empty" do
      params = %{}

      assert {:ok, %ListPlayersObject{} = list_players_object} =
               ListPlayersObject.from_params(params)

      assert %PageObject{} = list_players_object.page
      assert %SearchObject{} = list_players_object.search
      assert %SortObject{} = list_players_object.sort
    end

    test "returns and error with an invalid changeset when params are invalid" do
      page = -1
      page_size = -1
      q = "%_"
      field = Faker.Lorem.word()
      direction = Faker.Lorem.word()
      sort = "#{field}:#{direction}"

      params = %{
        "page" => page,
        "page_size" => page_size,
        "q" => q,
        "sort" => sort
      }

      assert {:error, changeset} = ListPlayersObject.from_params(params)

      assert %Changeset{valid?: false} = changeset

      assert errors_on(changeset) == %{
               page: %{page: ["must be greater than 0"], page_size: ["must be greater than 0"]},
               search: %{q: ["can't contain unsafe characters"]},
               sort: %{direction: ["is invalid"], field: ["is invalid"]}
             }
    end
  end

  describe "sort_fields/0" do
    test "returns a list with the fields that can be sorted by" do
      assert ListPlayersObject.sort_fields() ==
               [:total_rushing_yards, :longest_rush, :total_rushing_touchdowns]
    end
  end
end
