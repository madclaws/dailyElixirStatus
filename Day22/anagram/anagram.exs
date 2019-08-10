defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    Enum.filter(candidates, fn candid -> String.bag_distance(String.downcase(base),
    String.downcase(candid)) === 1.0 and String.downcase(base) !== String.downcase(candid)
  end)
  end
end
