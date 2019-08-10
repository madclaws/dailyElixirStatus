defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    str = String.downcase(sentence)
    Regex.split(~r/([^\w\-]|_)+/u, str)
      |> Enum.filter(fn word -> word !== "" end)
      |> Enum.reduce(%{}, fn word, acc_map -> Map.update(acc_map, word, 1, &(&1 + 1)) end)

  end
end
