defmodule OcrNumbers do
  require Logger
  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.
  """
  @spec convert([String.t()]) :: String.t()
  def convert(input) do
  end

  #############################################################################
  #  OCR Validation Checking functions

  def is_valid?(input) do
    is_valid_rows?(input)
    |> is_valid_columns?(input)
  end

  defp is_valid_rows?(input) when is_list(input), do: rem(Enum.count(input), 4) === 0
  defp is_valid_rows?(_), do: false

  defp is_valid_columns?(is_valid_rows, input)
  defp is_valid_columns?(true, input) do
    case are_column_numbers_okay?(input) do
      true -> true
      false -> {:error, 'invalid column count'}
    end
  end
  defp is_valid_columns?(false, _), do: {:error, 'invalid line count'}

  defp are_column_numbers_okay?(input)  do
    Enum.all?(input, fn row_element ->
      rem(String.length(row_element), 3) === 0
    end)
  end

#################################################################################

# Convert single line

def convert_single_line(input) do
  {converted_number, _} = hd(input) |> String.length() |> get_list_from_range()
  |> Enum.reduce({"", 0}, fn _index, {converted_number, slice_start} ->
    converted_digit = get_ocr_digit_list(slice_start, input) |> convert_digit
    {converted_number <> converted_digit, slice_start + 3}
  end)
  converted_number
end

def get_ocr_digit_list(slice_start, input) do
  Enum.reduce(input, [], fn element, ocr_list ->
    ocr_list ++ [String.slice(element, slice_start, 3)]
  end)
end

defp get_list_from_range(len) do
  for i <- 0..div(len, 3) - 1, do: i
end
















#################################################################################
#     Pattern matching functions for OCR => number

  def convert_digit([
    " _ ",
    "| |",
    "|_|",
    "   "
  ]), do: "0"

  def convert_digit([
    "   ",
    "  |",
    "  |",
    "   "
  ]), do: "1"

  def convert_digit([
    " _ ",
    " _|",
    "|_ ",
    "   "
  ]), do: "2"

  def convert_digit([
    " _ ",
    " _|",
    " _|",
    "   "
  ]), do: "3"

  def convert_digit([
    "   ",
    "|_|",
    "  |",
    "   "
  ]), do: "4"

  def convert_digit([
    " _ ",
    "|_ ",
    " _|",
    "   "
  ]), do: "5"

  def convert_digit([
    " _ ",
    "|_ ",
    "|_|",
    "   "
  ]), do: "6"

  def convert_digit([
    " _ ",
    "  |",
    "  |",
    "   "
  ]), do: "7"

  def convert_digit([
    " _ ",
    "|_|",
    "|_|",
    "   "
  ]), do: "8"

  def convert_digit([
    " _ ",
    "|_|",
    " _|",
    "   "
  ]), do: "9"

  def convert_digit(_), do: "?"
##################################################################################
end
