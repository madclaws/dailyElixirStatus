defmodule Contractor.PoolServer do
  require Logger
  use GenServer
  # Client functions
  defmodule State do
    defstruct pool_sup: nil,
              size: nil,
              mfa: nil,
              worker_sup: nil,
              workers: nil,
              monitor: nil,
              name: nil,
              overflow: nil,
              max_overflow: nil,
              waiting: nil
  end

  def start_link([_pool_sup, pool_config] = params) do
    GenServer.start_link(__MODULE__, params, name: :"#{pool_config[:name]}Server")
  end

  def checkout_worker(pool_name, block, timeout) do
    GenServer.call(:"#{pool_name}Server", {:checkout, block}, timeout)
  end

  def checkin_worker(pool_name, worker_pid) do
    GenServer.cast(:"#{pool_name}Server", {:checkin, worker_pid})
  end

  def get_status(pool_name) do
    GenServer.call(:"#{pool_name}Server", :status)
  end

  # Server functions
  @impl true
  def init([pool_sup, pool_config]) when is_pid(pool_sup) do
    Process.flag(:trap_exit, true)
    monitor = :ets.new(:monitors, [:private])
    Logger.info("#{inspect(pool_config)}")

    init(pool_config, %State{
      pool_sup: pool_sup,
      monitor: monitor,
      name: "#{pool_config[:name]}Server"
    })
  end

  def init([{:name, _name}, {:mfa, mfa}, {:size, size}, {:max_overflow, max_overflow}], state) do
    send(self(), :start_worker_supervisor)
    waiting_queue = :queue.new()
    {:ok, %State{state | mfa: mfa, size: size, max_overflow: max_overflow, waiting: waiting_queue}}
  end

  @impl true
  def handle_info(:start_worker_supervisor, state) do
    # start the worker supervisor
    Logger.info("state #{inspect(state)}")

    {:ok, worker_sup} =
      Supervisor.start_child(state.pool_sup, get_worker_supervisor_spec(state.name))

    worker_list = spin_up_workers(state.size, state.mfa, state.name)
    Enum.each(worker_list, fn worker -> Process.link(worker) end )
    {:noreply, %State{state | worker_sup: worker_sup, workers: worker_list}}

  end

  @impl true
  def handle_info({:EXIT, pid, _reason}, %{overflow: overflow} = state) do
    case :ets.lookup(state.monitor, pid) do
      [{pid, ref}] ->
        true = Process.demonitor(ref)
        true = :ets.delete(state.monitor, pid)
        if overflow > 0 do
          {:noreply, %State{state | overflow: overflow - 1}}
        else
          {:noreply, %State{state | workers: [hd(spin_up_workers(1, state.mfa, state.name)) | state.workers]}}
        end
      [] ->
        {:noreply, state}
    end
  end


  @impl true
  def handle_info({:DOWN, ref, _, _, _}, state) do
    case :ets.match(state.monitor, {:"$1", ref}) do
      [[worker_pid]] ->
        true = :ets.delete(state.monitor, worker_pid)
        {:noreply, %State{state | workers: [worker_pid | state.workers]}}

      [] ->
        {:noreply, state}
    end
  end

  @impl true
  def handle_call(
        {:checkout, block},
        {consumer_pid, _ref} = from,
        %{max_overflow: max_overflow, overflow: overflow} = state
      ) do
    case state.workers do
      [worker_pid | rest] ->
        ref = Process.monitor(consumer_pid)
        true = :ets.insert(state.monitor, {worker_pid, ref})
        {:reply, worker_pid, %State{state | workers: rest}}

      [] when max_overflow > 0 and overflow < max_overflow ->
        ref = Process.monitor(consumer_pid)
        worker_pid = hd(spin_up_workers(1, state.mfa, state.name))
        true = :ets.insert(state.monitor, {worker_pid, ref})
        {:reply, worker_pid, %State{state | overflow: overflow + 1}}
      [] when block === true ->
        ref = Process.monitor(consumer_pid)
        waiting_queue = :queue.in({from, ref}, state.waiting)
        {:noreply, %State{state | waiting: waiting_queue}, :infinity}
      [] ->
        {:reply, :full, state}
    end
  end

  def handle_call(:status, _from, state) do
    {:reply, {state_name(state), length(state.workers), :ets.info(state.monitor, :size)}, state}
  end

  @impl true
  def handle_cast({:checkin, worker_pid}, %{overflow: overflow} = state) do
    case :ets.lookup(state.monitor, worker_pid) do
      [{pid, ref}] ->
        true = Process.demonitor(ref)
        true = :ets.delete(state.monitor, pid)
        if overflow > 0 do
          :ok = Contractor.WorkerSupervisor.kill_child(state.name, pid)
          {:noreply, %State{state | overflow: overflow - 1}}
        else
          {:noreply, %State{state | workers: [pid | state.workers]}}
        end

      [] ->
        {:noreply, state}
    end
  end

  # helper functions
  defp get_worker_supervisor_spec(name) do
    Supervisor.child_spec({Contractor.WorkerSupervisor, [self(), name]},
      type: :supervisor,
      restart: :temporary,
      id: "#{name}_worker_sup"
    )
  end

  # defp fismiss_worker(pid, worker_sup_name) do
  #   DynamicSupervisor.terminate_child(supervisor, pid)
  # end

  defp spin_up_workers(size, mfa, name) do
    for _x <- 1..size do
      Contractor.WorkerSupervisor.start_child(mfa, name)
    end
    |> Enum.map(fn {_, worker} -> worker end)
  end

  defp state_name(%{max_overflow: max_overflow, overflow: overflow} = state) when overflow < 1 do
    case length(state.workers) === 0 do
      true ->
        if max_overflow < 1 do
          :full
        else
          :overflow
        end
      false -> :ready
    end
  end
  defp state_name(%{max_overflow: max_overflow, overflow: max_overflow} = _state) do
    :full
  end
  defp state_name(_), do: :overflow
end
