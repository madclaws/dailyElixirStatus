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
  def flatten(list, flatten_list \\ [])
  def flatten([], flatten_list), do: flatten_list
  def flatten([h | t], flatten_list), do: flatten(t, flatten(h,  flatten_list))
  def flatten(h, flatten_list) when h === nil, do: flatten_list
  def flatten(h, flatten_list), do: flatten_list ++ [h]


end
