defmodule NflRushingWeb.SelectComponent do
  use NflRushingWeb, :live_component

  @selected_attr "selected"

  @spec render(map) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~L"""
    <select name="<%= @name %>" class="border-1 font-medium form-select rounded-md text-gray-900">
      <%= for option <- @options do %>
        <option value="<%= option.value %>" <%= put_selected_attribute(option, @value) %>><%= option.name %></option>
      <% end %>
    </select>
    """
  end

  defp put_selected_attribute(option, current_value) do
    has_empty_value? = is_nil(current_value) or current_value == ""
    use_default? = has_empty_value? and is_default?(option)
    is_selected? = current_value == option.value

    if use_default? or is_selected? do
      @selected_attr
    else
      nil
    end
  end

  defp is_default?(%{default?: default?}), do: default?
  defp is_default?(_), do: false
end
