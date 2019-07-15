defmodule Scrabble do
  @doc """
  Calculate the scrabble score for the word.
  """
  @score_letter %{
    "A" => 1,
    "B" => 3,
    "C" => 3,
    "M" => 3,
    "P" => 3,
    "E" => 1,
    "I" => 1,
    "O" => 1,
    "U" => 1,
    "L" => 1,
    "N" => 1,
    "R" => 1,
    "S" => 1,
    "T" => 1,
    "D" => 2,
    "G" => 2,
    "F" => 4,
    "H" => 4,
    "V" => 4,
    "W" => 4,
    "Y" => 4,
    "K" => 5,
    "J" => 8,
    "X" => 8,
    "Q" => 10,
    "Z" => 10
  }
  @spec score(String.t()) :: non_neg_integer
  def score(word) do
  String.upcase(word)
  |> String.codepoints
  |> Enum.reduce(0, fn letter, score ->
    score + fetch_correct_score(Map.fetch(@score_letter, letter)) end
    )
  end

  def fetch_correct_score({:ok, val}), do: val
  def fetch_correct_score(:error), do: 0
end
