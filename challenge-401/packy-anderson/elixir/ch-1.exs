#!/usr/bin/env elixir

defmodule PWC do
  @top ~r/^
    (?<numerator> [+-]? \d+ ) \/ (?<denominator> [+-]? \d+ )
    (?<remaining> .* )
  $ /ux

  defp int(val) when is_integer(val), do: val
  defp int(val) when is_float(val), do: trunc(val)
  defp int(val), do: String.to_integer(val)

  def parse_fractions(expr, fractions) do
    parsed = Regex.named_captures(@top, expr)

    fractions =
      fractions ++
        [
          %{
            numerator: int(parsed["numerator"]),
            denominator: int(parsed["denominator"])
          }
        ]

    if parsed["remaining"] != "" do
      parse_fractions(parsed["remaining"], fractions)
    else
      fractions
    end
  end

  def add_fractions(a, b) do
    {a, b} =
      if a.denominator != b.denominator do
        {anum, adenom, bnum, bdenom} =
          {a.numerator * b.denominator,
           a.denominator * b.denominator,
           b.numerator * a.denominator,
           b.denominator * a.denominator}

        {%{numerator: anum, denominator: adenom},
         %{numerator: bnum, denominator: bdenom}}
      else
        {a, b}
      end

    sum = a.numerator + b.numerator
    %{numerator: sum, denominator: a.denominator}
  end

  def simplify_fraction(%{
        numerator: numerator,
        denominator: denominator
      }) do
    if numerator == 0 do
      "0/1"
    else
      d = Integer.gcd(numerator, denominator)
      "#{int(numerator / d)}/#{int(denominator / d)}"
    end
  end

  def fractional_addition_substraction(expr) do
    parse_fractions(expr, [])
    |> Enum.reduce(fn a, b -> add_fractions(a, b) end)
    |> simplify_fraction()
  end

  def solution(expr) do
    IO.puts("Input: $expr = \"#{expr}\"")
    result = fractional_addition_substraction(expr)
    IO.puts("Output: \"#{result}\"")
  end
end

IO.puts("Example 1")
PWC.solution("1/2+3/2")

IO.puts("\nExample 2")
PWC.solution("-5/2-3/2")

IO.puts("\nExample 3")
PWC.solution("5/3-5/3")

IO.puts("\nExample 4")
PWC.solution("10/10-1/10+2/5")

IO.puts("\nExample 5")
PWC.solution("1/6+1/6+1/6")
