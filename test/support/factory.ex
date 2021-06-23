defmodule NflRushing.Factory do
  use ExMachina.Ecto, repo: NflRushing.Repo

  alias NflRushing.League.Player
  alias NflRushing.League.PlayerStatistic
  alias NflRushing.League.Team

  @spec player_factory() :: Player.t()
  def player_factory do
    name = Faker.Person.name()

    position =
      2
      |> Faker.Lorem.characters()
      |> List.to_string()
      |> String.upcase()

    player_statistic = build(:player_statistic)
    team = build(:team)

    %Player{
      name: name,
      position: position,
      statistic: player_statistic,
      team: team
    }
  end

  @spec team_factory() :: Team.t()
  def team_factory do
    abbreviation =
      3
      |> Faker.Lorem.characters()
      |> List.to_string()
      |> String.upcase()

    %Team{
      abbreviation: abbreviation
    }
  end

  @spec player_statistic_factory() :: PlayerStatistic.t()
  def player_statistic_factory do
    longest_rush = 100 |> :rand.uniform() |> to_string()

    %PlayerStatistic{
      average_rushing_attempts_per_game: :rand.uniform(),
      average_rushing_yards_per_attempt: :rand.uniform(),
      longest_rush: longest_rush,
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
  end
end
