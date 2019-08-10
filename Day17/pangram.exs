defmodule Pangram do
  @doc """
  Determines if a word or sentence is a pangram.
  A pangram is a sentence using every letter of the alphabet at least once.

  Returns a boolean.

    ## Examples

      iex> Pangram.pangram?("the quick brown fox jumps over the lazy dog")
      true

  """

  @spec pangram?(String.t()) :: boolean
  def pangram?(sentence) do
    sentence_letters = String.downcase(sentence) |> String.codepoints
    Enum.all?(get_alphabet_list(), fn letter -> letter in sentence_letters end)
  end

  def get_alphabet_list, do: for i <- ?a..?z, do: <<i::utf8>>
end
