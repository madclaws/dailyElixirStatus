defmodule Binary do
  require Logger
  @doc """
  Convert a string containing a binary number to an integer.

  On errors returns 0.
  """
  @spec to_decimal(String.t()) :: non_neg_integer
  def to_decimal(string) do
    case is_valid_binary?(string) do
      false -> 0
      true -> convert_to_decimal(string)
    end

  end

  defp convert_to_decimal(string) do
    {converted_number, _} = String.codepoints(string)
    |> Enum.reverse
    |> Enum.reduce({0, 0}, fn place_value, acc_result ->
      {decimal_number, count} = acc_result
      {decimal_number + (String.to_integer(place_value) * pow(2, count)), count + 1}
    end)
    converted_number;
  end

  def pow(num, power, result \\ 1)
  def pow(_num, 0, result), do: result
  def pow(num, power, result), do: pow(num, power - 1, num * result)

  def is_valid_binary?(binary_string) do
     String.codepoints(binary_string)
    |> Enum.all?(fn binary ->
      binary === "1" or binary === "0"
    end)
  end
end
