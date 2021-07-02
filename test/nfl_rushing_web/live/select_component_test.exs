defmodule NflRushingWeb.SelectComponentTest do
  use NflRushingWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias NflRushingWeb.SelectComponent

  describe "render/1" do
    test "renders a select tag with given assigns" do
      options = [
        %{name: "Option 1", value: "option-1"},
        %{name: "Option 2", value: "option-2"}
      ]

      assert {:ok, select_component} =
               SelectComponent
               |> render_component(name: "test", options: options, value: "")
               |> Floki.parse_fragment()

      assert [select_element] = Floki.find(select_component, "select[name=test]")
      assert [option_1, option_2] = Floki.children(select_element)

      assert ["option-1"] == Floki.attribute(option_1, "value")
      assert "Option 1" == Floki.text(option_1)
      assert ["option-2"] == Floki.attribute(option_2, "value")
      assert "Option 2" == Floki.text(option_2)
    end

    test "renders a select tag without options when options are not informed" do
      options = []

      {:ok, select_component} =
        SelectComponent
        |> render_component(name: "test", options: options, value: "")
        |> Floki.parse_fragment()

      assert [select_element] = Floki.find(select_component, "select[name=test]")
      assert [] == Floki.children(select_element)
    end

    test "renders a select tag with the default option selected when value is a empty string" do
      options = [
        %{name: "Option 1", value: "option-1", default?: true},
        %{name: "Option 2", value: "option-2"}
      ]

      {:ok, select_component} =
        SelectComponent
        |> render_component(name: "test", options: options, value: "")
        |> Floki.parse_fragment()

      assert [select_element] = Floki.find(select_component, "select[name=test]")
      assert [option_1, option_2] = Floki.children(select_element)

      assert ["selected"] == Floki.attribute(option_1, "selected")
      assert [] == Floki.attribute(option_2, "selected")
    end

    test "renders a select tag with the default option selected when value is nil" do
      options = [
        %{name: "Option 1", value: "option-1", default?: true},
        %{name: "Option 2", value: "option-2"}
      ]

      {:ok, select_component} =
        SelectComponent
        |> render_component(name: "test", options: options, value: nil)
        |> Floki.parse_fragment()

      assert [select_element] = Floki.find(select_component, "select[name=test]")
      assert [option_1, option_2] = Floki.children(select_element)

      assert ["selected"] == Floki.attribute(option_1, "selected")
      assert [] == Floki.attribute(option_2, "selected")
    end

    test "renders a select tag with a custom option selected when value is not empty" do
      options = [
        %{name: "Option 1", value: "option-1", default?: true},
        %{name: "Option 2", value: "option-2"}
      ]

      {:ok, select_component} =
        SelectComponent
        |> render_component(name: "test", options: options, value: "option-2")
        |> Floki.parse_fragment()

      assert [select_element] = Floki.find(select_component, "select[name=test]")
      assert [option_1, option_2] = Floki.children(select_element)

      assert [] == Floki.attribute(option_1, "selected")
      assert ["selected"] == Floki.attribute(option_2, "selected")
    end
  end
end
