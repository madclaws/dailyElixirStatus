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
  def in_english(0), do: {:ok, "zero"}
  def in_english(number) when number > 0 and number < 999_999_999_999 do
    english_text = break_number_to_chunks(number)
    |> insert_scale_word
    |> putting_it_together
    {:ok, english_text}
  end

  def in_english(_) do
    {:error, "number is out of range"}
  end

  # Phase 1 -> Converting number to english upto 2 digits
  def  convert_only_two(number) when number >= 0 and number < 100, do: convert_two_digits(div(number, 10), rem(number, 10))

  defp convert_two_digits(tens_place_digit, ones_place_digit)
  defp convert_two_digits(0, 0), do: ""
  defp convert_two_digits(1, ones_place_digit), do: @place_value_texts[ones_place_digit]["spcase"]
  defp convert_two_digits(tens_place_digit, 0), do: @place_value_texts[tens_place_digit]["tens"]
  defp convert_two_digits(0, ones_place_digit), do: @place_value_texts[ones_place_digit]["ones"]
  defp convert_two_digits(tens_place_digit, ones_place_digit) do
    @place_value_texts[tens_place_digit]["tens"] <> "-" <> @place_value_texts[ones_place_digit]["ones"]
  end

  # Phase 2 -> Breaking the number by chunks of 3.

  def break_number_to_chunks(number, chunk_list \\ [])
  def break_number_to_chunks(0, chunk_list), do: chunk_list
  def break_number_to_chunks(number, chunk_list) do
    break_number_to_chunks(div(number, 1000), [rem(number, 1000) | chunk_list])
  end
  def break_number_to_chunks(_, _), do: raise "ArgumentError"

  # Phase 3 -> inserting corresponding scale word(like "million") between the chunks

  def insert_scale_word(chunk_list) do
    scale_limit = Enum.count(chunk_list) - 1
    {scaled_string, _} = Enum.reduce(chunk_list, {"", scale_limit}, fn num, acc_tuple ->
      handle_chunks_and_scale(num, acc_tuple)
    end)
    scaled_string |> String.trim_trailing |> String.trim_leading
  end


  defp handle_chunks_and_scale(0, {acc_str, acc_count}) do
    {acc_str <> "", acc_count - 1}
  end
  defp handle_chunks_and_scale(num, {acc_str, acc_count}) do
    {acc_str <> " " <> Integer.to_string(num) <> " " <> @scale_word[acc_count], acc_count - 1}
  end

  # Phase 4 -> Putting all together and  adding hundred text if any.

  def putting_it_together(number_string) do
    final_res = String.split(number_string)
    |> Enum.reduce("", fn str, acc_num_str ->
      cur_str = case Regex.match?(~r/[a-z]/, str) do
        true -> str
        false -> handle_number_case(str)
      end
      acc_num_str <> cur_str
    end)
    String.trim(final_res)
  end

  def handle_number_case(str) do
    num = String.trim(str) |> String.to_integer
    hundred_place = div(num, 100)
    tens_place = rem(num, 100)
    hundred_str = cond do
      hundred_place === 0 -> ""
      true -> " " <> convert_only_two(hundred_place) <> " " <>  "hundred"
    end
    tens_str = convert_only_two(tens_place)
    hundred_str <> " " <> tens_str <> " "
  end

end
