defmodule NflRushingWeb.TeamView do
  use NflRushingWeb, :view

  @spec render(String.t(), map) :: map

  def render("team.json", %{team: team}) do
    %{
      abbreviation: team.abbreviation
    }
  end
end
