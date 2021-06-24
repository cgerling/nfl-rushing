defmodule NflRushing.Importer.ParserTest do
  use ExUnit.Case, async: true

  alias NflRushing.Importer.Parser

  describe "normalize_as_string/1" do
    test "returns a string when the value is a boolean" do
      assert "true" == Parser.normalize_as_string(true)
      assert "false" == Parser.normalize_as_string(false)
    end

    test "returns a string when the value is an integer" do
      value = :rand.uniform(1000)
      string_value = to_string(value)

      assert string_value == Parser.normalize_as_string(value)
    end

    test "returns a string when the value is a float" do
      value = :rand.uniform()
      string_value = to_string(value)

      assert string_value == Parser.normalize_as_string(value)
    end

    test "returns a string when the value is a string" do
      value = Faker.Lorem.word()
      string_value = to_string(value)

      assert string_value == Parser.normalize_as_string(value)
    end
  end

  describe "normalize_as_integer/1" do
    test "returns an integer when the value is an integer" do
      value = :rand.uniform(1000)

      assert value == Parser.normalize_as_integer(value)
    end

    test "returns an integer when the value is a string" do
      integer = :rand.uniform(1000)
      value = to_string(integer)

      assert integer == Parser.normalize_as_integer(value)
    end

    test "returns an integer when the value is a string and has commas" do
      value = "1,500"

      assert 1500 == Parser.normalize_as_integer(value)
    end

    test "returns nil when the value is invalid" do
      value = nil

      assert value |> Parser.normalize_as_integer() |> is_nil()
    end
  end
end
