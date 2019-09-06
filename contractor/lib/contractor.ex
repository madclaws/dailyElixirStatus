defmodule Contractor do
  use Application
  require Logger
  @timeout 5000
  def start(_types, _args) do
    pools_config = [
      [name: "pool1", mfa: {Contractor.SampleWorker, :start_link, []}, size: 5, max_overflow: 0],
      [name: "pool2", mfa: {Contractor.SampleWorker, :start_link, []}, size: 2, max_overflow: 2],
      [name: "pool3", mfa: {Contractor.SampleWorker, :start_link, []}, size: 3, max_overflow: 0]
    ]

    Logger.info("Starting Contractor")
    start_contractor(pools_config)
  end

  def start_contractor(pools_config) do
    Contractor.Supervisor.start_link(pools_config)
  end

  def checkout(pool_name, block \\ true, timeout \\ @timeout) do
    Contractor.Server.checkout_worker(pool_name, block, timeout)
  end

  def checkin(pool_name, worker_pid) do
    Contractor.Server.checkin_worker(pool_name, worker_pid)
  end

  def status(pool_name) do
    Contractor.Server.get_status(pool_name)
  end
end
