defmodule Antichrist do

  require Logger
  @moduledoc """
  Documentation for Antichrist.
  """


  def run(n_workers, url) do
    worker_fn = fn -> Antichrist.Worker.start(url) end
    1..n_workers
    |> Enum.map(fn _ -> Task.async(worker_fn) end)
    |> Enum.map(&Task.await(&1, :infinity))
    |> parse_results()
  end

  defp parse_results(results) do
    {sucesses, _failures} = results
                          |> Enum.split_with(fn item ->
                            case item do
                              {:ok, _} -> true
                              _ -> false
                            end
                          end)
    total_workers = Enum.count(results)
    total_success = Enum.count(sucesses)
    total_failure = total_workers - total_success
    data = sucesses |> Enum.map(fn {:ok, time} -> time end)
    average_time = average(data)
    longest_time = Enum.max(data)
    smallest_time = Enum.min(data)

    IO.puts """
    Total workers : #{total_workers}
    Successful reqs : #{total_success}
    Failed res : #{total_failure}
    Average (msecs) : #{average_time}
    Longest (msecs) : #{longest_time}
    Shortest (msecs) : #{smallest_time}
    """
  end

  defp average(data) when length(data) === 0, do: 0
  defp average(data) do
    Enum.sum(data) / Enum.count(data)
  end

end
