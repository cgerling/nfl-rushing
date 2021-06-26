defmodule NflRushing.League.PlayerStatisticTest do
  use NflRushing.DataCase, async: true

  alias Ecto.Changeset
  alias NflRushing.League.PlayerStatistic

  describe "changeset/2" do
    @valid_params %{
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

    test "returns a valid changeset when params are valid" do
      changeset = PlayerStatistic.changeset(%PlayerStatistic{}, @valid_params)

      assert %Changeset{valid?: true} = changeset
    end

    test "returns an invalid changeset when required params are not present" do
      invalid_params = %{}
      changeset = PlayerStatistic.changeset(%PlayerStatistic{}, invalid_params)

      assert %Changeset{valid?: false} = changeset

      assert errors_on(changeset) == %{
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
    end
  end
end
