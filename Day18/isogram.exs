defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence) do
    Regex.scan(~r/[a-zA-Z]/, sentence) |> List.flatten |> is_isogram?
  end

  defp is_isogram?(charlist, is_check_failed \\ nil)
  defp is_isogram?(_, true), do: false
  defp is_isogram?([], _), do: true
  defp is_isogram?([h | t], _is_check_failed), do: is_isogram?(t, h in t)
end
