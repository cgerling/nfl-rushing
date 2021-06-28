defmodule NflRushingWeb.PlayersLive do
  use NflRushingWeb, :live_view

  alias NflRushing.League
  alias NflRushingWeb.PageObject
  alias NflRushingWeb.SearchObject
  alias NflRushingWeb.SelectComponent
  alias NflRushingWeb.SortObject
  alias NflRushingWeb.TableComponent

  @sort_fields [:total_rushing_yards, :longest_rush, :total_rushing_touchdowns]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, page_object} = PageObject.from_params(%{})
    {:ok, search_object} = SearchObject.from_params(%{})
    {:ok, sort_object} = SortObject.from_params(%{}, allowed_fields: @sort_fields)

    socket =
      assign(socket,
        loading: true,
        page: page_object,
        players: [],
        total_entries: 0,
        search: search_object,
        sort: sort_object
      )

    list_players(socket)

    {:ok, socket}
  end

  @impl true
  def handle_event("apply-options", params, socket) do
    with {:ok, %SearchObject{} = search_object} <- SearchObject.from_params(params),
         {:ok, %SortObject{} = sort_object} <-
           SortObject.from_params(params, allowed_fields: @sort_fields) do
      socket =
        socket
        |> assign(search: search_object, sort: sort_object)
        |> list_players()

      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("next-page", _, socket) do
    page = socket.assigns.page
    total_entries = socket.assigns.total_entries

    if page_end_index(page, total_entries) >= total_entries do
      {:noreply, socket}
    else
      socket = change_page(socket, page.page + 1)
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("previous-page", _, socket) do
    page = socket.assigns.page
    socket = change_page(socket, page.page - 1)

    {:noreply, socket}
  end

  defp change_page(socket, page_number) when is_integer(page_number) do
    page = socket.assigns.page
    new_page = %{page | page: page_number}

    new_page
    |> Map.from_struct()
    |> PageObject.from_params()
    |> case do
      {:ok, %PageObject{} = page_object} ->
        socket
        |> assign(page: page_object)
        |> list_players()

      _ ->
        socket
    end
  end

  @impl true
  def handle_info({:list_players, options}, socket) do
    %{count: count, entries: players} = League.list_players(options)

    socket = assign(socket, loading: false, players: players, total_entries: count)

    {:noreply, socket}
  end

  defp list_players(socket) do
    send(self(), {:list_players, socket.assigns})
    assign(socket, loading: true)
  end

  defp page_begin_index(page) do
    (page.page - 1) * page.page_size + 1
  end

  defp page_end_index(page, total_entries) do
    end_index = page.page * page.page_size

    if end_index > total_entries do
      total_entries
    else
      end_index
    end
  end

  defp sort_options,
    do: [
      %{name: "Newest to oldest", value: "", default?: true},
      %{name: "Less Yds", value: "total_rushing_yards:asc", default?: false},
      %{name: "Most Yds", value: "total_rushing_yards:desc", default?: false},
      %{name: "Less Lng", value: "longest_rush:asc", default?: false},
      %{name: "Most Lng", value: "longest_rush:desc", default?: false},
      %{name: "Less TD", value: "total_rushing_touchdowns:asc", default?: false},
      %{name: "Most TD", value: "total_rushing_touchdowns:desc", default?: false}
    ]

  defp player_headers,
    do: [
      "Player",
      "Team",
      "Position",
      "Att/G",
      "Att",
      "Yds",
      "Avg",
      "Yds/G",
      "TD",
      "Lng",
      "1st",
      "1st%",
      "20+",
      "40+",
      "FUM"
    ]

  defp player_mapper(player) do
    [
      player.name,
      player.team.abbreviation,
      player.position,
      player.statistic.average_rushing_attempts_per_game,
      player.statistic.rushing_attempts,
      player.statistic.total_rushing_yards,
      player.statistic.average_rushing_yards_per_attempt,
      player.statistic.rushing_yards_per_game,
      player.statistic.total_rushing_touchdowns,
      player.statistic.longest_rush,
      player.statistic.rushing_first_downs,
      player.statistic.rushing_first_downs_percentage,
      player.statistic.rushing_twenty_yards_each,
      player.statistic.rushing_fourty_yards_each,
      player.statistic.rushing_fumbles
    ]
  end
end
