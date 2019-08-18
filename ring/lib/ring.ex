defmodule Ring do
  require Logger
  @moduledoc """
  Documentation for Ring.
  """

  def create_process(total_processes) do
    1..total_processes |> Enum.map(fn _count->
      spawn(__MODULE__, :loop, [])
    end)
  end

  def loop() do
    receive do
      {:link, link_to_pid} ->
        Process.monitor(link_to_pid)
      :crash -> 1 / 0
      {:EXIT, pid, reason} ->
        Logger.info("#{inspect(pid)} exited with #{inspect(reason)}")
      {:DOWN, _ref, _, pid, reason} ->
        Logger.info("#{inspect(pid)} crashed with a reason #{inspect(reason)}")
      end
    loop()
  end

  def link_process(process_list) do
    link_process(process_list, [])
  end

  @spec link_process([...], [any]) :: any
  def link_process([proc1, proc2 | rest], linked_process_list) do
    send(proc1, {:link, proc2})
    link_process([proc2 | rest], [proc1 | linked_process_list])
  end

  def link_process([proc | []], linked_process_list) do
    send(proc, {:link, List.last(linked_process_list)})
  end

  def add_trap_feature(proc_list) do
    proc_list |> Enum.each(fn proc_id ->
      Process.send(proc_id, :trap, [])
    end)
  end
  def crash_any_process(process_list) do
    process_list |> Enum.shuffle() |> hd() |> send(:crash)
  end

end
