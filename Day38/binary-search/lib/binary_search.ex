defmodule BinarySearch do
  require Logger
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(number_tuple_list, key)

  def search({}, _key), do: :not_found

  def search(numbers_tuple, key) do
    Tuple.to_list(numbers_tuple)
    |> finder(key, 0, tuple_size(numbers_tuple) - 1, div(tuple_size(numbers_tuple) - 1, 2))
  end

  defp finder(number_list, key, start_pos, start_pos, mid_pos) do
    case Enum.at(number_list, mid_pos) === key do
      true -> {:ok, mid_pos}
      false -> :not_found
    end
  end

  defp finder(number_list, key, start_pos, end_pos, mid_pos) do
    cond do
      Enum.at(number_list, mid_pos) === key -> {:ok, mid_pos}
      Enum.at(number_list, mid_pos) < key -> finder(number_list, key, mid_pos + 1, end_pos,
      div(mid_pos + 1 + end_pos, 2))
      Enum.at(number_list, mid_pos) > key -> finder(number_list, key, start_pos, mid_pos - 1,
      div(start_pos + (mid_pos - 1), 2))
    end
  end
end
