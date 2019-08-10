defmodule Raindrops do
  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t()
  def convert(number) do
    Enum.reduce([3, 5, 7], "", fn factor, acc ->
      acc <> check_factor(rem(number, factor) == 0, factor, String.equivalent?(acc, ""), number) end)

  end

  def check_factor(true, 3,_, _), do: "Pling"
  def check_factor(true, 5, _, _), do:  "Plang"
  def check_factor(true, 7, _, _), do:  "Plong"
  def check_factor(false, 7, true, integer_number), do: Integer.to_string(integer_number)
  def check_factor(false, _, _, _), do: ""
end
