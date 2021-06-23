defmodule NflRushing.League.PlayerTest do
  use NflRushing.DataCase, async: true

  alias Ecto.Changeset
  alias NflRushing.League.Player
  alias NflRushing.Repo

  describe "changeset/2" do
    @valid_params %{
      name: Faker.Person.name(),
      position: 2 |> Faker.Lorem.characters() |> List.to_string(),
      team_id: Ecto.UUID.generate()
    }

    test "returns a valid changeset when params are valid" do
      changeset = Player.changeset(%Player{}, @valid_params)

      assert %Changeset{valid?: true} = changeset
    end

    test "returns an invalid changeset when required params are not present" do
      invalid_params = %{}
      changeset = Player.changeset(%Player{}, invalid_params)

      assert %Changeset{valid?: false} = changeset

      assert errors_on(changeset) == %{
               name: ["can't be blank"],
               position: ["can't be blank"],
               team_id: ["can't be blank"]
             }
    end

    test "returns an invalid changeset on insert when team does not exists" do
      changeset = Player.changeset(%Player{}, @valid_params)

      assert {:error, changeset} = Repo.insert(changeset)
      assert %Changeset{valid?: false} = changeset
      assert errors_on(changeset) == %{team: ["does not exist"]}
    end
  end
end
