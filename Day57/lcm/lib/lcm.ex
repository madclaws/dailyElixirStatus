defmodule Lcm do
  @moduledoc """
  Documentation for Lcm.
  """
  def hcf(num1, num1), do: num1
  def hcf(num1, num2) when num1 > num2, do: hcf(num1 - num2, num2)
  def hcf(num1, num2), do: hcf(num1, num2 - num1)

  def lcm(num1, num2), do: num1 * num2 |> div(hcf(num1, num2))
end
