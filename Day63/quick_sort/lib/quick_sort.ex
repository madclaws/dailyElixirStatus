defmodule QuickSort do
  
  def sort([]), do: []

  def sort([pivot | t]) do
     sort(for i <- t, i < pivot, do: i)
     ++ [pivot] ++ sort(for i <- t, i >= pivot, do: i)
  end
  
end
