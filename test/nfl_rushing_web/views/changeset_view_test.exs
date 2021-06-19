defmodule NflRushingWeb.ChangesetViewTest do
  use NflRushingWeb.ConnCase, async: true

  alias Ecto.Changeset
  alias NflRushingWeb.ChangesetView

  describe "render/2" do
    test "returns a map with a error message based on the changeset" do
      data = %{}
      types = %{field: :string}
      params = %{field: "value"}

      changeset =
        {data, types}
        |> Changeset.cast(params, Map.keys(types))
        |> Changeset.validate_required(Map.keys(types))
        |> Changeset.validate_length(:field, is: 10)

      assert ChangesetView.render("error.json", %{changeset: changeset}) == %{
               errors: %{field: ["should be 10 character(s)"]}
             }
    end
  end
end
