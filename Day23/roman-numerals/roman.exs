defmodule Roman do

  @ones_place %{
    1 => "I",
    2 => "II",
    3 => "III",
    4 => "IV",
    5 => "V",
    6 => "VI",
    7 => "VII",
    8 => "VIII",
    9 => "IX"
  }
  @ten "X"
  @fifty "L"
  @hundred "C"
  @five_hundred "D"
  @thousand "M"

  @doc """
  Convert the number to a roman number.
  """
  @spec numerals(pos_integer) :: String.t()
  def numerals(number) when number > 0 and number <= 3000 do
    max_digit_place = (Integer.digits(number) |> Enum.count) - 1
    {roman_string, _} = Enum.reduce(Integer.digits(number), {"", max_digit_place}, fn num, acc_tuple ->
      get_roman_numerals(num, acc_tuple)
    end)
    roman_string
  end

  defp get_roman_numerals(0, {acc_str, digit_place}), do: {acc_str, digit_place - 1}
  defp get_roman_numerals(number, {acc_str, 0}), do: {acc_str <> @ones_place[number], -1}
  defp get_roman_numerals(number, {acc_str, 1}), do: {acc_str <> get_tens_place(number), 0}
  defp get_roman_numerals(number, {acc_str, 2}), do: {acc_str <> get_hundreds_place(number), 1}
  defp get_roman_numerals(number, {acc_str, 3}), do: {acc_str <> get_thousands_place(number), 2}

  defp get_tens_place(4), do: @ten <> @fifty
  defp get_tens_place(9), do: @ten <> @hundred
  defp get_tens_place(5), do: @fifty
  defp get_tens_place(number) when number < 5, do: String.duplicate(@ten, number)
  defp get_tens_place(number), do: @fifty <> String.duplicate(@ten, number - 5)

  defp get_hundreds_place(4), do: @hundred <> @five_hundred
  defp get_hundreds_place(9), do: @hundred <> @thousand
  defp get_hundreds_place(5), do: @five_hundred
  defp get_hundreds_place(number) when number < 5, do: String.duplicate(@hundred, number)
  defp get_hundreds_place(number), do: @five_hundred <> String.duplicate(@hundred, number - 5)

  defp get_thousands_place(number), do: String.duplicate(@thousand, number)
end
