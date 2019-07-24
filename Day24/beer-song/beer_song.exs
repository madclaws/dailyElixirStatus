defmodule BeerSong do

  @doc """
  Get a single verse of the beer song
  """
  @spec verse(integer) :: String.t()
  def verse(0) do
    "No more #{get_bottle_of_beer(nil)} on the wall, no more #{get_bottle_of_beer(nil)}.\n" <>
    "Go to the store and buy some more, 99 #{get_bottle_of_beer(99)} on the wall.\n"
  end

  def verse(1) do
    "1 #{get_bottle_of_beer(1)} on the wall, 1 #{get_bottle_of_beer(1)}.\n" <>
    "Take it down and pass it around, no more #{get_bottle_of_beer(nil)} on the wall.\n"
  end

  def verse(number) when number > 1 and number <= 99 do
    "#{number} #{get_bottle_of_beer(number)} on the wall, #{number} #{get_bottle_of_beer(number)}.\n" <>
    "Take one down and pass it around, #{number - 1} #{get_bottle_of_beer(number - 1)} on the wall.\n"
  end

  defp get_bottle_of_beer(number_of_bottles)
  defp get_bottle_of_beer(1), do: "bottle of beer"
  defp get_bottle_of_beer(_), do: "bottles of beer"

  @doc """
  Get the entire beer song for a given range of numbers of bottles.
  """
  @spec lyrics(Range.t()) :: String.t()
  def lyrics(range \\ 99..0) do
    Enum.reduce(range, "", fn bottle_number, total_lyrics ->
      total_lyrics <> "\n" <> verse(bottle_number)
    end)
    |> String.trim_leading
  end
end
