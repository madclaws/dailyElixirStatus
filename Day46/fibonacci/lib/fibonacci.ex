defmodule Fibonacci do
  require Logger
  @moduledoc """
  Documentation for Fibonacci.
  """
  def print_fibonnaci(length) when length > 1 do
    prepare_fibonnaci(0, 1, [0, 1], length)
  end

  def print_fibonnaci(_), do: "Give a length greater than 1"

  defp prepare_fibonnaci(_, _, fib_list, len) when length(fib_list) === len, do: fib_list
  defp prepare_fibonnaci(first , second, fib_list, len) do
    next = first + second
    first = second
    prepare_fibonnaci(first, next, fib_list ++ [next], len)
  end
end
