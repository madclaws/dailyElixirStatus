defmodule Ring do
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
        Process.link(link_to_pid)
      :crash -> 1 / 0
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

  def crash_any_process(process_list) do
    process_list |> Enum.shuffle() |> hd() |> send(:crash)
  end

end
