defmodule IsbnVerifier do
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> ISBNVerifier.isbn?("3-598-21507-X")
      true

      iex> ISBNVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) do
    parsed_isbn = isbn
                  |> String.split("-")
                  |> Enum.join
    validate_isbn(parsed_isbn, String.match?(parsed_isbn, ~r/^\d{10}$/),
    String.match?(parsed_isbn, ~r/^\d{9}X$/))
  end

  defp validate_isbn(isbn, is_normal_matching, is_matching_x_check)
  defp validate_isbn(isbn, true, _) do
    {compute_value, _} = isbn |> compute_isbn()
    rem(compute_value, 11) === 0
  end
  defp validate_isbn(isbn, _, true) do
    {compute_value, _} = isbn |> String.trim_trailing("X") |> compute_isbn()
    rem(compute_value + 10, 11) === 0
  end

  defp validate_isbn(_isbn, false, false) do
    false
  end

  defp compute_isbn(isbn) do
    isbn
    |> String.codepoints
    |> Enum.reduce({0, 10}, fn code, {acc, multiplier} ->
      result = String.to_integer(code) * multiplier
      {acc + result, multiplier - 1}
    end)
  end
end
