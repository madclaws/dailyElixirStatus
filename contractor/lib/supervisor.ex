defmodule Contractor.Supervisor do
  use Supervisor

  #################
  #client functions
  #################

  def start_link(pool_config) do
    Supervisor.start_link(__MODULE__, pool_config, name: __MODULE__)
  end

  ##################
  # Server functions
  ##################

@impl true
def init(pool_config) do
  children = [
    # Add child spec of Contractor.PoolsSupervisor
    %{
      id: Contractor.PoolsSupervisor,
      start: {Contractor.PoolsSupervisor, :start_link, []},
      type: :supervisor
    },
    {Contractor.Server, [pool_config]}
  ]
  Supervisor.init(children, strategy: :one_for_all)
end

end
