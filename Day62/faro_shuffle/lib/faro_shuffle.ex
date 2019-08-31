defmodule FaroShuffle do
  def shuffle(list) do
    # first normal shuffle.
    shuffle_faro(list, length(list) - 2)
  end


  defp shuffle_faro(list, 1), do: list

  defp shuffle_faro(list, shuffle_length) do
    shuffle_index = Enum.random(1..shuffle_length)
    shuffle_value = Enum.at(list, shuffle_index)
    shuffle_list = List.replace_at(list, shuffle_index, Enum.at(list, shuffle_length))
                   |> List.replace_at(shuffle_length, shuffle_value)
    shuffle_faro(shuffle_list, shuffle_length - 1)
  end
end
