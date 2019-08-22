defmodule Contractor.Server do
  use GenServer
  # import Supervisor, only: [child_spec: 2, start_child: 2]
  defmodule State do
    defstruct sup: nil, size: nil, mfa: nil, worker_sup: nil, workers: nil
  end

  ##################
  # Client functions
  ##################
  def start_link([_sup, _pool_config] = params) do
    GenServer.start_link(__MODULE__, params, name: __MODULE__)
  end

  ##################
  # Server functions
  ##################
  @impl true
  def init([sup, pool_config]) when is_pid(sup) do
      init(pool_config, %State{sup: sup})
  end

  def init([{:mfa, mfa}, {:size, size}], state) do
    send(state.sup, :start_worker_supervisor)
    {:ok, %State{state | mfa: mfa, size: size}}
  end

  @impl true
  def handle_info(:start_worker_supervisor, state) do
    # start the worker supervisor
    {:ok, worker_sup} = Supervisor.start_child(state.sup, get_worker_supervisor_spec())
    worker_list = spin_up_workers(state.size, state.mfa)
    {:noreply, %State{state | worker_sup: worker_sup, workers: worker_list}}
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
