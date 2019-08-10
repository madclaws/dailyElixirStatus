defmodule MadSupervisor do
  def start_link(limits) do
    spawn_link(__MODULE__, :init, [limits])
  end

  def init(limits) do
    Process.flag(:trap_exit, true)
    limit_pid_map = Enum.map(limits, fn limit ->
      pid = run_child(limit)
      {pid, limit}
    end) |> Enum.into(%{})
    loop(limit_pid_map)
  end

  def run_child(limit)  do
    spawn_link(MadChild, :init, [limit])
  end

  def loop(limit_pid_map) do
    receive do

      {:EXIT, pid, _} -> IO.puts("Child id exited , #{inspect pid}")
      {limit, rest_limit_pid_map} = pop_in limit_pid_map[pid]
      new_pid = run_child(limit)
      IO.puts("Restarting the process #{limit} with new pid #{inspect(new_pid)}")
      rest_limit_pid_map = put_in rest_limit_pid_map[new_pid], limit
      loop(rest_limit_pid_map)
    end
  end
end

defmodule MadChild do
  def init(limit) do
    loop(limit)
  end
  def loop(0), do: :ok
  def loop(n) when n > 0 do
    Process.sleep(500)
    loop(n - 1)
  end
end

MadSupervisor.start_link([2, 3, 5])
Process.sleep(5000)

