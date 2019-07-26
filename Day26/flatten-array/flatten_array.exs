defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten(list) do
    flatten_process(list, []) |> Enum.reverse
  end

  def flatten_process([], flatten_list), do: flatten_list
  def flatten_process([h | t], flatten_list), do: flatten_process(t, flatten_process(h,  flatten_list))
  def flatten_process(h, flatten_list) when h === nil, do: flatten_list
  def flatten_process(h, flatten_list), do: [h | flatten_list]
end
