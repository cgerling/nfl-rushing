defmodule NflRushing.League.TeamTest do
  use NflRushing.DataCase, async: true

  alias Ecto.Changeset
  alias NflRushing.League.Team

  describe "changeset/2" do
    @valid_params %{
      abbreviation: Faker.Team.name()
    }

    test "returns a valid changeset when params are valid" do
      changeset = Team.changeset(%Team{}, @valid_params)

      assert %Changeset{valid?: true} = changeset
    end

    test "returns an invalid changeset when required params are not present" do
      invalid_params = %{}
      changeset = Team.changeset(%Team{}, invalid_params)

      assert %Changeset{valid?: false} = changeset
      assert errors_on(changeset) == %{abbreviation: ["can't be blank"]}
    end
  end
end
