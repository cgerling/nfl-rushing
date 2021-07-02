defmodule NflRushingWeb.TableComponent do
  use NflRushingWeb, :live_component

  @spec render(map) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    mapper = Map.get(assigns, :mapper) || (& &1)

    ~L"""
    <table class="min-w-full">
      <thead class="border-b-8 border-opacity-0">
        <tr>
          <%= for header <- @headers do %>
            <th scope="col" class="bg-gray-100 font-semibold px-3 py-5 rounded-l-md text-gray-500 text-center text-sm tracking-wide"><%= header %></th>
          <% end %>
        </tr>
      </thead>
      <tbody class="border-opacity-0 border-t-8 divide-y divide-gray-200">
        <%= for entry <- @entries do %>
          <tr>
            <%= for column_value <- mapper.(entry) do %>
              <td class="font-normal px-3 py-4 text-gray-600 text-center text-sm whitespace-nowrap"><%= column_value %></td>
            <% end %>
          </tr>
        <% end %>
      </tbody>
    </table>
    """
  end
end
