defmodule Grains do

  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer) :: pos_integer
  def square(number) when number < 1 or number > 64, do:  {:error, "The requested square must be between 1 and 64 (inclusive)"}
  def square(number), do: {:ok, pow(2, number - 1)}

  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: pos_integer
  def total do
    total_grains = Enum.reduce(1..64, 0, fn number, accumulated_square ->
      {:ok, squared_number} = square(number)
      accumulated_square + squared_number
    end)
    {:ok, total_grains}
  end

  def pow(num, power, result \\ 1)
  def pow(_num, 0, result), do: result
  def pow(num, power, result), do: pow(num, power - 1, num * result)
end



