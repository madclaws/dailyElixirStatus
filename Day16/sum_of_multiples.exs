defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors) when limit > 0 do
    1..limit - 1
    |> Enum.filter(fn num ->
      Enum.any?(factors, fn fac -> rem(num, fac) == 0 end)
    end)
    |> Enum.sum
  end
  def to(_, _), do: "invalid"
end
