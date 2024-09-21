defmodule HexDepSearch do
  @moduledoc """
  Documentation for `HexDepSearch`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> HexDepSearch.hello()
      :world

  """
  def hello do
    :world
  end

  import NimbleParsec

  eol =
    choice([
      string("\r\n"),
      string("\n"),
      eos()
    ])

  allowed_chars =
    ascii_string([?a..?z, ?A..?Z, ?0..?9, ?-, ?_, ?:, ?/, ?.], 1)

  single_space =
    ascii_string([?\s], 1)

  single_space_surrounded =
    allowed_chars
    |> concat(single_space)
    |> concat(allowed_chars)

  column_bits =
    choice([
      single_space_surrounded,
      allowed_chars
    ])

  column =
    repeat(column_bits)
    |> reduce({Enum, :join, [""]})

  double_whitespace =
    ascii_string([?\s], min: 2)

  expression =
    column
    |> concat(ignore(double_whitespace))
    |> concat(ignore(column))
    |> concat(ignore(double_whitespace))
    |> concat(column)
    |> concat(ignore(double_whitespace))
    |> concat(ignore(column))
    |> ignore(optional(eol))

  defparsec(:line_parser, expression)

  def run([package_name]) do
    search_package(package_name)
    |> format_output()
    |> Enum.each(fn output ->
      # IO.puts ensures output is written line by line
      IO.puts(output)
    end)
  end

  def main(args) do
    run(args)
  end

  defp search_package(package_name) do
    {output, 0} = System.cmd("mix", ["hex.search", package_name])

    output
    |> String.split("\n")
    |> Enum.filter(fn line -> String.contains?(line, package_name) end)
  end

  def format_output(package_line) do
    package_line
    |> Enum.map(&format_package/1)
  end

  def format_package(line) do
    case line_parser(line) do
      {:ok, [pkg, version], _, _, _, _} ->
        "{:#{pkg}, \"~> #{version}\"}"

      _ ->
        "Invalid format"
    end
  end
end
