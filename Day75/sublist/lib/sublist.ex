defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, a), do: :equal
  def compare(a, b) when length(a) === length(b), do: :unequal
  def compare(a, b) when length(a) > length(b) do
    case check_sublist(b, a, nil) do
      true -> :superlist
      false -> :unequal
    end
  end
  def compare(a, b) do
    case check_sublist(a, b, nil) do
      true -> :sublist
      false -> :unequal
    end
  end

  defp check_sublist([], _, _), do: true
  defp check_sublist(_, [], _), do: false
  defp check_sublist(_, _, true), do: true
  defp check_sublist([h | _tail_small_list] = small_list, [h | _tail_big_list] = big_list, _is_sublist) do
    {_, big_list} = List.pop_at(big_list, Enum.count(big_list) - 1)
    check_sublist(small_list, big_list, small_list === big_list)
  end
  defp check_sublist(small_list, [_h | tail_big_list], _is_sublist) do
    check_sublist(small_list, tail_big_list, small_list === tail_big_list)
  end
end
