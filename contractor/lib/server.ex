defmodule Contractor.Server do
  use GenServer
  require Logger
  # import Supervisor, only: [child_spec: 2, start_child: 2]
  defmodule State do
    defstruct sup: nil, size: nil, mfa: nil, worker_sup: nil, workers: nil, monitor: nil
  end

  ##################
  # Client functions
  ##################
  def start_link([_sup, _pool_config] = params) do
    GenServer.start_link(__MODULE__, params, name: __MODULE__)
  end

  def checkout_worker() do
    GenServer.call(__MODULE__, :checkout)
  end

  def checkin_worker(worker_pid) do
    GenServer.cast(__MODULE__, {:checkin, worker_pid})
  end

  def get_status() do
    GenServer.call(__MODULE__, :status)
  end

  ##################
  # Server functions
  ##################
  @impl true
  def init([sup, pool_config]) when is_pid(sup) do
    monitor = :ets.new(:monitors, [:private])
    init(pool_config, %State{sup: sup, monitor: monitor})
  end

  def init([{:mfa, mfa}, {:size, size}], state) do
    send(self(), :start_worker_supervisor)
    {:ok, %State{state | mfa: mfa, size: size}}
  end

  @impl true
  def handle_info(:start_worker_supervisor, state) do
    # start the worker supervisor
    Logger.info("state #{inspect(state)}")
    {:ok, worker_sup} = Supervisor.start_child(state.sup, get_worker_supervisor_spec())
    worker_list = spin_up_workers(state.size, state.mfa)
    {:noreply, %State{state | worker_sup: worker_sup, workers: worker_list}}
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

  ##################
  # Helper functions
  ##################

  defp get_worker_supervisor_spec() do
    Supervisor.child_spec(Contractor.WorkerSupervisor,  type: :supervisor, restart: :temporary)
  end

  defp spin_up_workers(size, mfa) do
    for _x <- 1..size  do
      Contractor.WorkerSupervisor.start_child(mfa)
    end
    |> Enum.map(fn {_, worker} -> worker end)
  end

end
