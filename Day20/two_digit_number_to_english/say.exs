defmodule Say do

  @place_value_texts %{
    1 => %{"tens" => "ten", "ones" => "one", "spcase" => "eleven"},
    2 => %{"tens" => "twenty", "ones" => "two", "spcase" => "twelve"},
    3 => %{"tens" => "thirty", "ones" => "three", "spcase" => "thirteen"},
    4 => %{"tens" => "forty", "ones" => "four", "spcase" => "fourteen"},
    5 => %{"tens" => "fifty", "ones" => "five", "spcase" => "fifteen"},
    6 => %{"tens" => "sixty", "ones" => "six", "spcase" => "sixteen"},
    7 => %{"tens" => "seventy", "ones" => "seven", "spcase" => "seventeen"},
    8 => %{"tens" => "eighty", "ones" => "eight", "spcase" => "eighteen"},
    9 => %{"tens" => "ninty", "ones" => "nine", "spcase" => "nineteen"}
  }

  @scale_word %{
    0 => "",
    1 => "thousand",
    2 => "million",
    3 => "billion",
    4 => "trillion"
  }

  @doc """
  Translate a positive integer into English.
  """
  @spec in_english(integer) :: {atom, String.t()}
  def in_english(number) when number >= 0 and number < 100 do
    convert_two_digits(div(number, 10), rem(number, 10))
  end
  def in_english(_) do
    raise "ArgumentError"
  end

  defp convert_two_digits(tens_place_digit, ones_place_digit)
  defp convert_two_digits(0, 0), do: "zero"
  defp convert_two_digits(1, ones_place_digit), do: @place_value_texts[ones_place_digit]["spcase"]
  defp convert_two_digits(tens_place_digit, 0), do: @place_value_texts[tens_place_digit]["tens"]
  defp convert_two_digits(0, ones_place_digit), do: @place_value_texts[ones_place_digit]["ones"]
  defp convert_two_digits(tens_place_digit, ones_place_digit) do
    @place_value_texts[tens_place_digit]["tens"] <> "-" <> @place_value_texts[ones_place_digit]["ones"]
  end
end
