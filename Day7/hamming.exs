defmodule Hamming do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance('AAGTCATA', 'TAGCGATC')
  {:ok, 4}
  """
  @spec hamming_distance([char], [char]) :: {:ok, non_neg_integer} | {:error, String.t()}
  def hamming_distance(strand1, strand2) do
    hamming_distance_check(strand1, strand2, 0)
  end

  def hamming_distance_check([], [], hamming_count), do: {:ok, hamming_count}
  def hamming_distance_check([], _strand2, _hamming_count), do: {:error, "Lists must be the same length"}
  def hamming_distance_check(_strand1, [], _hamming_count), do: {:error, "Lists must be the same length"}
  def hamming_distance_check([_h | tail], [_h | rest], hamming_count), do: hamming_distance_check(tail, rest, hamming_count)
  def hamming_distance_check([_h | tail], [_m | rest], hamming_count), do: hamming_distance_check(tail, rest, hamming_count + 1)

end
