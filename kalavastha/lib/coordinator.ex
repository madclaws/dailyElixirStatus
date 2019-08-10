defmodule Kalavastha.Coordinator do
  @moduledoc """
    Module that acts as a receiver for Workers.

    It coordinates all the weather data it receives and prints it.
  """

  def loop(weather_info_list, exit_count) do
    receive do
      {:ok, weather_info} ->
        weather_info_list = [weather_info | weather_info_list]
        if Enum.count(weather_info_list) === exit_count do
          IO.puts("DONEEE")
          send(self(), :exit)
        end
        loop(weather_info_list, exit_count)
      :exit ->
         result = weather_info_list |> Enum.sort() |> Enum.join("\n")
         IO.puts(result)
       _ -> loop(weather_info_list, exit_count)
    end

  end
end
