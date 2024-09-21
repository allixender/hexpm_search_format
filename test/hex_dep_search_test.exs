defmodule HexDepSearchTest do
  use ExUnit.Case

  doctest HexDepSearch

  # a fixture that represents default hex.search output
  defp hex_search_output do
    line =
      "postgrex             PostgreSQL driver for Elixir                   0.19.1  https://hex.pm/packages/postgrex\n"

    line
  end

  test "greets the world" do
    assert HexDepSearch.hello() == :world
  end

  # test the format_package function
  test "format_package" do
    hex_output = hex_search_output()
    IO.puts(hex_output)
    # hex_search_output text pipe to test parser
    assert "{:postgrex, \"~> 0.19.1\"}" = HexDepSearch.format_package(hex_output)
  end
end
