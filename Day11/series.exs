defmodule StringSeries do
  @doc """
  Given a string `s` and a positive integer `size`, return all substrings
  of that size. If `size` is greater than the length of `s`, or less than 1,
  return an empty list.
  """
  @spec slices(s :: String.t(), size :: integer) :: list(String.t())
  def slices(str, size) when size > 0 do
    length = String.graphemes(str) |> length
    cond do
      (length - size) >= 0 -> Enum.map(0..(length - size), fn start -> String.slice(str, start, size) end)
      true -> []
    end
  end
  def slices(_, _), do: []
end
