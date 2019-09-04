defmodule Contractor.PoolSupervisor do
  use Supervisor
  require Logger

  def start_link(pool_config) do
    Supervisor.start_link(__MODULE__, pool_config, name: :"#{pool_config[:name]}Supervisor")
  end

  def init(pool_config) do
    children = [
      {Contractor.PoolServer, [self(), pool_config]}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
