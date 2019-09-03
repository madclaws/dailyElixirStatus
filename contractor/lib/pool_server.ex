defmodule Contractor.PoolServer do
  require Logger
  use GenServer
  # Client functions
  defmodule State do
    defstruct pool_sup: nil, size: nil, mfa: nil, worker_sup: nil, workers: nil, monitor: nil, name: nil
  end

  def start_link([_pool_sup, pool_config] = params) do
    GenServer.start_link(__MODULE__, params, name: :"#{pool_config[:name]}Server")
  end

  def checkout_worker(pool_name) do
    GenServer.call(:"#{pool_name}Server", :checkout)
  end

  def checkin_worker(pool_name, worker_pid)  do
    GenServer.cast(:"#{pool_name}Server", {:checkin, worker_pid})
  end

  def get_status(pool_name)  do
    GenServer.call(:"#{pool_name}Server", :status)
  end

  # Server functions
  @impl true
  def init([pool_sup, pool_config]) when is_pid(pool_sup) do
    monitor = :ets.new(:monitors, [:private])
    init(pool_config, %State{pool_sup: pool_sup, monitor: monitor, name: "#{pool_config[:name]}Server"})
  end

  def init([{:name, name}, {:mfa, mfa}, {:size, size}], state) do
    send(self(), :start_worker_supervisor)
    {:ok, %State{state | mfa: mfa, size: size}}
  end

  @impl true
  def handle_info(:start_worker_supervisor, state) do
    # start the worker supervisor
    Logger.info("state #{inspect(state)}")
    {:ok, worker_sup} = Supervisor.start_child(state.pool_sup, get_worker_supervisor_spec(state.name))
    worker_list = spin_up_workers(state.size, state.mfa, state.name)
    {:noreply, %State{state | worker_sup: worker_sup, workers: worker_list}}
  end

  @impl true
  def handle_info({:EXIT, _worker_sup, reason}, state)  do
      {:stop, reason, state}
  end

  @impl true
  def handle_info({:DOWN, ref, _, _, _}, state) do
    case :ets.match(state.monitor, {:"$1", ref}) do
      [[worker_pid]] ->
        true = :ets.delete(state.monitor, worker_pid)
        {:noreply, %State{state | workers: [worker_pid | state.workers]}}
      [] -> {:noreply, state}
    end
  end

  @impl true
  def handle_call(:checkout, {consumer_pid, _ref}, state) do
    case state.workers do
      [worker_pid | rest] ->
        ref = Process.monitor(consumer_pid)
        true = :ets.insert(state.monitor, {worker_pid, ref})
        {:reply, worker_pid, %State{ state | workers: rest}}
      [] -> {:reply, :noproc, state}
    end
  end

  def handle_call(:status, _from, state) do
    {:reply, {length(state.workers), :ets.info(state.monitor, :size)}, state}
  end

  @impl true
  def handle_cast({:checkin, worker_pid}, state) do
    case :ets.lookup(state.monitor, worker_pid) do
      [{pid, ref}] ->
        true = Process.demonitor(ref)
        true = :ets.delete(state.monitor, pid)
        {:noreply, %State{ state | workers: [pid | state.workers]}}
      [] ->
        {:noreply, state}
    end
  end

  # helper functions
  defp get_worker_supervisor_spec(name) do
    Supervisor.child_spec({Contractor.WorkerSupervisor, self()},  type: :supervisor, restart: :temporary, id: "#{name}_worker_sup")
  end

  defp spin_up_workers(size, mfa, name) do
    for _x <- 1..size  do
      Contractor.WorkerSupervisor.start_child(mfa, name)
    end
    |> Enum.map(fn {_, worker} -> worker end)
  end

end
