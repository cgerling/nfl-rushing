defmodule NflRushingWeb.PageObjectTest do
  use ExUnit.Case, async: true

  import NflRushing.DataHelper

  alias Ecto.Changeset
  alias NflRushingWeb.PageObject

  describe "changeset/2" do
    @valid_params %{
      page: :rand.uniform(100),
      page_size: :rand.uniform(100)
    }

    test "returns a valid changeset when params are valid" do
      changeset = PageObject.changeset(%PageObject{}, @valid_params)

      assert %Changeset{valid?: true} = changeset
    end

    test "returns a valid changeset with default values when params are empty" do
      empty_params = %{}
      changeset = PageObject.changeset(%PageObject{}, empty_params)

      assert %Changeset{valid?: true} = changeset
      assert 1 == Changeset.get_field(changeset, :page)
      assert 30 == Changeset.get_field(changeset, :page_size)
    end

    test "returns an invalid changeset when page param is less than 1" do
      invalid_params = %{@valid_params | page: 0}
      changeset = PageObject.changeset(%PageObject{}, invalid_params)

      assert %Changeset{valid?: false} = changeset
      assert errors_on(changeset) == %{page: ["must be greater than 0"]}
    end

    test "returns an invalid changeset when page_size param is less than 1" do
      invalid_params = %{@valid_params | page_size: 0}
      changeset = PageObject.changeset(%PageObject{}, invalid_params)

      assert %Changeset{valid?: false} = changeset
      assert errors_on(changeset) == %{page_size: ["must be greater than 0"]}
    end
  end

  describe "from_params/1" do
    test "returns a ok with a struct containing the informed values when params are valid" do
      page = :rand.uniform(100)
      page_size = :rand.uniform(100)
      params = %{"page" => page, "page_size" => page_size}

      assert {:ok, %PageObject{} = page_object} = PageObject.from_params(params)

      assert page_object.page == page
      assert page_object.page_size == page_size
    end

    test "returns a ok with a struct containing the default values when params are empty" do
      empty_params = %{}

      assert {:ok, %PageObject{} = page_object} = PageObject.from_params(empty_params)

      assert page_object.page == 1
      assert page_object.page_size == 30
    end

    test "returns an error with an invalid changeset when params are not valid" do
      invalid_params = %{"page" => 0, "page_size" => 0}

      assert {:error, changeset} = PageObject.from_params(invalid_params)

      assert %Changeset{valid?: false} = changeset
      assert :parse == changeset.action

      assert errors_on(changeset) == %{
               page: ["must be greater than 0"],
               page_size: ["must be greater than 0"]
             }
    end
  end
end
