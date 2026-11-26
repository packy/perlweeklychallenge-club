#!/usr/bin/env elixir

defmodule PWC do
  def bag(str), do: String.codepoints(str) |> Enum.frequencies()

  def num_bag(digit),
    do:
      Enum.at(
        [
          bag("zero"),
          bag("one"),
          bag("two"),
          bag("three"),
          bag("four"),
          bag("five"),
          bag("six"),
          bag("seven"),
          bag("eight"),
          bag("nine")
        ],
        digit
      )

  def subset?(big, small) do
    small
    |> Map.keys()
    |> Enum.reduce(true, fn key, acc ->
      acc && Map.has_key?(big, key) &&
        Map.get(big, key) >= Map.get(small, key)
    end)
  end

  def delete_subset(big, small) do
    small
    |> Map.keys()
    |> Enum.reduce(big, fn key, big ->
      {_, big} =
        Map.get_and_update(big, key, fn val ->
          newval = val - Map.get(small, key)
          if newval > 0, do: {val, newval}, else: :pop
        end)

      big
    end)
  end

  def reconstruct_digits([], output, charbag) do
    out = output |> Enum.sort() |> Enum.join()

    if charbag != %{} do
      elements =
        charbag
        |> Map.keys()
        |> Enum.reduce([], fn c, list ->
          list ++ List.duplicate(c, Map.get(charbag, c))
        end)
        |> Enum.join(" ")

      raise "#{out}, but extra characters were found: #{elements}"
    else
      out
    end
  end

  def reconstruct_digits([digit | remain], output, charbag) do
    nbag = num_bag(digit)

    if subset?(charbag, nbag) do
      charbag = delete_subset(charbag, nbag)
      output = output ++ [digit]
      reconstruct_digits([digit | remain], output, charbag)
    else
      reconstruct_digits(remain, output, charbag)
    end
  end

  def reconstruct_digits(str) do
    reconstruct_digits(
      [0, 2, 4, 6, 8, 7, 5, 3, 1, 9],
      [],
      bag(str)
    )
  end

  def solution(str) do
    IO.puts("Input: $str = \"#{str}\"")
    output = reconstruct_digits(str)
    IO.puts("Output: \"#{output}\"")
  end
end

IO.puts("Example 1")
PWC.solution("zroezerotwotwotwo")

IO.puts("\nExample 2")
PWC.solution("sveeeinght")

IO.puts("\nExample 3")
PWC.solution("onenineninefive")

IO.puts("\nExample 4")
PWC.solution("zeroonetwothreeeightfivesixsevenninefour")

IO.puts("\nExample 5")
PWC.solution("ninenineninenine")

IO.puts("\nExample 6")
PWC.solution("onestewv")
