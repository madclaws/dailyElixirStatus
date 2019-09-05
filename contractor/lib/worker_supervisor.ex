defmodule Contractor.WorkerSupervisor do
  use DynamicSupervisor

  ##################
  # Client functions
  ##################

  def start_link([pool_server, name] = _params) do
    DynamicSupervisor.start_link(__MODULE__, pool_server, name: :"#{name}_worker_sup")
  end

  def start_child({m, _f, a}, name) do
    spec = {m, a}
    DynamicSupervisor.start_child(:"#{name}_worker_sup", spec)
  end

  def kill_child(name, pid) do
    DynamicSupervisor.terminate_child(:"#{name}_worker_sup", pid)
  end
  ##################
  # Server functions
  ##################
  @impl true
  def init(pool_server) do
    Process.link(pool_server)

    DynamicSupervisor.init(
      strategy: :one_for_one,
      max_restarts: 5,
      max_seconds: 5
    )
  end
end
