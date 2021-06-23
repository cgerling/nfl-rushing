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

  describe "import_changeset/1" do
    @valid_params %{
      name: Faker.Person.name(),
      position: 2 |> Faker.Lorem.characters() |> List.to_string(),
      team_id: Ecto.UUID.generate(),
      statistic: %{
        average_rushing_attempts_per_game: :rand.uniform(),
        average_rushing_yards_per_attempt: :rand.uniform(),
        longest_rush: 100 |> :rand.uniform() |> to_string(),
        rushing_attempts: :rand.uniform(100),
        rushing_first_downs: :rand.uniform(100),
        rushing_first_downs_percentage: :rand.uniform(),
        rushing_fourty_yards_each: :rand.uniform(100),
        rushing_fumbles: :rand.uniform(100),
        rushing_twenty_yards_each: :rand.uniform(100),
        rushing_yards_per_game: :rand.uniform(),
        total_rushing_touchdowns: :rand.uniform(100),
        total_rushing_yards: :rand.uniform(100)
      }
    }

    test "returns a valid changeset when params are valid" do
      changeset = Player.import_changeset(@valid_params)

      assert %Changeset{valid?: true} = changeset
    end

    test "returns an invalid changeset when required params are not present" do
      invalid_params = %{}
      changeset = Player.import_changeset(invalid_params)

      assert %Changeset{valid?: false} = changeset

      assert errors_on(changeset) == %{
               name: ["can't be blank"],
               position: ["can't be blank"],
               team_id: ["can't be blank"]
             }
    end

    test "returns an invalid changeset when statistic is not valid" do
      invalid_statistic = %{}
      params = %{@valid_params | statistic: invalid_statistic}
      changeset = Player.import_changeset(params)

      assert %Changeset{valid?: false} = changeset

      assert errors_on(changeset) == %{
               statistic: %{
                 average_rushing_attempts_per_game: ["can't be blank"],
                 average_rushing_yards_per_attempt: ["can't be blank"],
                 longest_rush: ["can't be blank"],
                 rushing_attempts: ["can't be blank"],
                 rushing_first_downs: ["can't be blank"],
                 rushing_first_downs_percentage: ["can't be blank"],
                 rushing_fourty_yards_each: ["can't be blank"],
                 rushing_fumbles: ["can't be blank"],
                 rushing_twenty_yards_each: ["can't be blank"],
                 rushing_yards_per_game: ["can't be blank"],
                 total_rushing_touchdowns: ["can't be blank"],
                 total_rushing_yards: ["can't be blank"]
               }
             }
    end

    test "returns an invalid changeset on insert when team does not exists" do
      changeset = Player.import_changeset(@valid_params)

      assert {:error, changeset} = Repo.insert(changeset)
      assert %Changeset{valid?: false} = changeset
      assert errors_on(changeset) == %{team: ["does not exist"]}
    end
  end
end
