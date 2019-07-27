defmodule CollatzConjecture do
  @doc """
  calc/1 takes an integer and returns the number of steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """
  @spec calc(input :: pos_integer()) :: non_neg_integer()
  def calc(input) when is_number(input) and input > 0 do
    calculate_collatz_conjecture(input, 0)
  end

  def calculate_collatz_conjecture(1, steps), do: steps
  def calculate_collatz_conjecture(number, steps) when rem(number, 2) === 0 do
    calculate_collatz_conjecture(div(number, 2), steps + 1)
  end
  def calculate_collatz_conjecture(number, steps) do
    calculate_collatz_conjecture((3 * number) + 1, steps + 1)
  end
end
