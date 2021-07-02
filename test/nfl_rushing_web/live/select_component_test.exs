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

      select_component =
        render_component(SelectComponent, name: "test", options: options, value: "")

      expected_html =
        ~s{<select name="test" class="border-1 font-medium form-select rounded-md text-gray-900">\n  \n    <option value="option-1" >Option 1</option>\n  \n    <option value="option-2" >Option 2</option>\n  \n</select>\n}

      assert select_component == expected_html
    end

    test "renders a select tag without options when options are not informed" do
      options = []

      select_component =
        render_component(SelectComponent, name: "test", options: options, value: "")

      expected_html =
        ~s{<select name=\"test\" class=\"border-1 font-medium form-select rounded-md text-gray-900\">\n  \n</select>\n}

      assert select_component == expected_html
    end

    test "renders a select tag with the default option selected when value is a empty string" do
      options = [
        %{name: "Option 1", value: "option-1", default?: true},
        %{name: "Option 2", value: "option-2"}
      ]

      select_component =
        render_component(SelectComponent, name: "test", options: options, value: "")

      expected_html =
        ~s{<select name="test" class="border-1 font-medium form-select rounded-md text-gray-900">\n  \n    <option value="option-1" selected>Option 1</option>\n  \n    <option value="option-2" >Option 2</option>\n  \n</select>\n}

      assert select_component == expected_html
    end

    test "renders a select tag with the default option selected when value is nil" do
      options = [
        %{name: "Option 1", value: "option-1", default?: true},
        %{name: "Option 2", value: "option-2"}
      ]

      select_component =
        render_component(SelectComponent, name: "test", options: options, value: nil)

      expected_html =
        ~s{<select name="test" class="border-1 font-medium form-select rounded-md text-gray-900">\n  \n    <option value="option-1" selected>Option 1</option>\n  \n    <option value="option-2" >Option 2</option>\n  \n</select>\n}

      assert select_component == expected_html
    end

    test "renders a select tag with a custom option selected when value is not empty" do
      options = [
        %{name: "Option 1", value: "option-1", default?: true},
        %{name: "Option 2", value: "option-2"}
      ]

      select_component =
        render_component(SelectComponent, name: "test", options: options, value: "option-2")

      expected_html =
        ~s{<select name="test" class="border-1 font-medium form-select rounded-md text-gray-900">\n  \n    <option value="option-1" >Option 1</option>\n  \n    <option value="option-2" selected>Option 2</option>\n  \n</select>\n}

      assert select_component == expected_html
    end
  end
end
