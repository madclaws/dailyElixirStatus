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
    {Contractor.Server, [self(), pool_config]}
  ]
  Supervisor.init(children, strategy: :one_for_all)
end

end
