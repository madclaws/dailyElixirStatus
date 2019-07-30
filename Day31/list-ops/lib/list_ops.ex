defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l, length \\ 0)
  def count([], length), do: length
  def count([_h | t], count), do: count(t, count + 1)

  @spec reverse(list) :: list
  def reverse(l, reverse_list \\ [])
  def reverse([], reverse_list), do: reverse_list
  def reverse([h | t], reverse_list), do: reverse(t, [h | reverse_list])

  @spec map(list, (any -> any)) :: list
  def map(l, f, mapped_list \\ [])
  def map([], _f, mapped_list), do: reverse(mapped_list)
  def map([h | t], f, mapped_list), do: map(t, f, [f.(h) | mapped_list])

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f, filtered_list \\ [])
  def filter([], _f, filtered_list), do: reverse(filtered_list)
  def filter([h | t], f, filtered_list) do
    case f.(h) do
      true -> filter(t, f, [h | filtered_list])
      false -> filter(t, f, filtered_list)
    end
  end

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce([], acc, _f), do: acc
  def reduce([h | t], acc, f), do: reduce(t, f.(h, acc), f)

  @spec append(list, list) :: list
  def append(a, b, appended_list \\ [])
  def append([], [], appended_list), do: reverse(appended_list)
  def append([], [h | t], appended_list), do: append([], t, [h | appended_list])
  def append([h | t], b, appended_list), do: append(t, b, [h | appended_list])


  @spec concat([[any]]) :: [any]
  def concat(ll) do
    concatenation(ll) |> reverse
  end

  defp concatenation(list, concatenation_list \\ [])
  defp concatenation([], concatenation_list), do: concatenation_list
  defp concatenation([h | t], concatenation_list), do: concatenation(t, concatenation(h,  concatenation_list))
  defp concatenation(h, concatenation_list) when h === nil, do: concatenation_list
  defp concatenation(h, concatenation_list), do: [h | concatenation_list]
end
