defmodule Phone do
  require Logger
  @doc """
  Remove formatting from a phone number.

  Returns "0000000000" if phone number is not valid
  (10 digits or "1" followed by 10 digits)

  ## Examples

  iex> Phone.number("212-555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 055-0100")
  "0000000000"

  iex> Phone.number("(212) 555-0100")
  "2125550100"

  iex> Phone.number("867.5309")
  "0000000000"
  """
  @spec number(String.t()) :: String.t()
  def number(raw) do
    cleaned_number = number_cleanser(raw)
    validate_number(String.length(cleaned_number), String.first(cleaned_number), cleaned_number)
  end

  defp number_cleanser(raw) do
    Regex.scan(~r/[0-9a-z]/, raw) |> List.flatten() |> Enum.join()
  end

  defp validate_number(11, "1", cleaned_number) do
    {_, proper_number} = String.next_codepoint(cleaned_number)
    validate_with_regex(proper_number)
  end
  defp validate_number(10, _, cleaned_number), do: validate_with_regex(cleaned_number)
  defp validate_number(_, _, _), do: "0000000000"
  defp validate_with_regex(number) do
    case String.match?(number,  ~r/([2-9]{1}[0-9]{2}){2}[0-9]{4}/) do
      true -> number
      false  -> "0000000000"
    end
  end

  @doc """
  Extract the area code from a phone number

  Returns the first three digits from a phone number,
  ignoring long distance indicator

  ## Examples

  iex> Phone.area_code("212-555-0100")
  "212"

  iex> Phone.area_code("+1 (212) 555-0100")
  "212"

  iex> Phone.area_code("+1 (012) 555-0100")
  "000"

  iex> Phone.area_code("867.5309")
  "000"
  """
  @spec area_code(String.t()) :: String.t()
  def area_code(raw) do
    number(raw) |> String.slice(0, 3)
  end

  @doc """
  Pretty print a phone number

  Wraps the area code in parentheses and separates
  exchange and subscriber number with a dash.

  ## Examples

  iex> Phone.pretty("212-555-0100")
  "(212) 555-0100"

  iex> Phone.pretty("212-155-0100")
  "(000) 000-0000"

  iex> Phone.pretty("+1 (303) 555-1212")
  "(303) 555-1212"

  iex> Phone.pretty("867.5309")
  "(000) 000-0000"
  """
  @spec pretty(String.t()) :: String.t()
  def pretty(raw) do
    validated_number = number(raw)
    pretty_print_validated_area_code = "(#{area_code(validated_number)}) "
    pretty_print_validated_rest = "#{String.slice(validated_number, 3, 3)}-#{String.slice(validated_number, 6, 4)}"
    pretty_print_validated_area_code <> pretty_print_validated_rest
  end
end
