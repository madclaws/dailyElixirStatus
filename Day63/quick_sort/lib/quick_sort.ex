defmodule QuickSort do
  
  def sort(list) do
    pivot = hd(list)
    IO.puts("pivot is #{pivot}")
    lower_list = list
    |> Enum.filter(fn element -> element < pivot end)
    upper_list = Enum.filter(list, fn element -> element >= pivot end) 
    lower_list
  end
  
end
