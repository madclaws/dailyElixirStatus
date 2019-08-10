defmodule Strain do
  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns true.

  Do not use `Enum.filter`.
  """
  @spec keep(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def keep(list, fun) do
    keeper(list, fun, [])
  end

  def keeper([], _, keep_list), do: keep_list
  def keeper([h | t], fun, keep_list) do
    case fun.(h) do
      true -> keeper(t, fun, keep_list ++ [h] )
      false -> keeper(t, fun, keep_list)
    end
  end
  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns false.

  Do not use `Enum.reject`.
  """
  @spec discard(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def discard(list, fun) do
    discarder(list, fun, [])
  end

  def discarder([], _, discard_list), do: discard_list
  def discarder([h | t], fun, discard_list) do
    case fun.(h) do
      false -> discarder(t, fun, discard_list ++ [h])
      true -> discarder(t, fun, discard_list)
    end
  end
end
