defmodule Contractor.WorkerSupervisor do
  use DynamicSupervisor

  ##################
  # Client functions
  ##################

  def start_link() do
    DynamicSupervisor.start_link(__MODULE__, %{},  name: __MODULE__)
  end

  def start_child({m, _f, a}) do
    spec = {m, a}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  ##################
  # Server functions
  ##################
@impl true
def init(_) do
  DynamicSupervisor.init(
    strategy: :one_for_one,
    max_restarts: 5,
    max_seconds: 5
  )
end

end
