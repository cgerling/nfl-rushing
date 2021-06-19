defmodule NflRushingWeb.ChangesetView do
  use NflRushingWeb, :view

  alias Ecto.Changeset

  @spec render(String.t(), map) :: map
  def render("error.json", %{changeset: %Changeset{} = changeset}) do
    errors = serialize_errors(changeset)
    %{errors: errors}
  end

  defp serialize_errors(%Changeset{} = changeset) do
    Changeset.traverse_errors(changeset, &serialize_field_errors/1)
  end

  defp serialize_field_errors({message, opts}) do
    Regex.replace(~r/%{(\w+)}/, message, fn _, key -> replace_message_values(key, opts) end)
  end

  defp replace_message_values(string_key, opts) do
    key = String.to_existing_atom(string_key)

    opts
    |> Keyword.get(key)
    |> to_string()
  end
end
