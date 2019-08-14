defmodule ArmstrongNumber do
  @moduledoc """
  Documentation for ArmstrongNumber.
  """

  def is_armstrong_number?(number) do
    length = number |> Integer.to_string() |> String.length()
    number
    |> Integer.to_string
    |> String.codepoints
    |> Enum.reduce(0, fn digit, total ->
      {num, _} = Integer.parse(digit)
      total + :math.pow(num, length)
    end)
    |> Kernel.round() === number
  end
end
