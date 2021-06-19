defmodule NflRushingWeb.ListPlayersObject do
  use NflRushingWeb, :object

  alias NflRushingWeb.PageObject
  alias NflRushingWeb.SearchObject
  alias NflRushingWeb.SortObject

  @type t :: %__MODULE__{
          page: PageObject.t(),
          search: SearchObject.t(),
          sort: SortObject.t()
        }

  @sort_fields [:total_rushing_yards, :longest_rush, :total_rushing_touchdowns]

  embedded_schema do
    embeds_one :page, PageObject
    embeds_one :search, SearchObject
    embeds_one :sort, SortObject
  end

  @spec changeset(%__MODULE__{}, map) :: Changeset.t()
  def changeset(%__MODULE__{} = struct, %{} = params) do
    page_object = PageObject.changeset(%PageObject{}, params)
    search_object = SearchObject.changeset(%SearchObject{}, params)
    sort_object = SortObject.changeset(%SortObject{}, params, allowed_fields: @sort_fields)

    struct
    |> change()
    |> put_embed(:page, page_object)
    |> put_embed(:search, search_object)
    |> put_embed(:sort, sort_object)
  end

  @spec from_params(map) :: {:ok, t()} | {:error, Changeset.t()}
  def from_params(%{} = params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action(:parse)
  end

  @spec sort_fields() :: list(atom)
  def sort_fields do
    @sort_fields
  end
end
