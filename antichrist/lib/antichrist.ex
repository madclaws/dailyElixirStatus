defmodule Antichrist do

  require Logger
  @moduledoc """
  Documentation for Antichrist.
  """


  def caller(n) do
    # Logger.info(inspect(self()))
    caller_pid = self()
    1..n
    |> Enum.map(fn _ -> spawn(fn -> Antichrist.Worker.start("www.foyohe.com", caller_pid) end) end)

    receive_looper(0, 0, n)
  end

  defp receive_looper(n, total_sec, totla_workers) do
    receive do
      {:ok, value} ->
        # Logger.info(value)
        if (n === (totla_workers - 1)) do
          Logger.info("Average time taken => #{(total_sec + value) / 10}")
        end
        if n < (totla_workers - 1) do
          receive_looper(n + 1, total_sec + value, totla_workers)
        end
      {:error, _reason} ->
        "error with a reason"
      :error ->
        "error"
      :stop ->
        "stoping"
    end

  end

end
