defmodule Contractor do
  use Application
  require Logger
  def start(_types, _args) do
    pools_config = [
                    [name: "pool1", mfa: {Contractor.SampleWorker, :start_link, []}, size: 5],
                    [name: "pool2", mfa: {Contractor.SampleWorker, :start_link, []}, size: 2],
                    [name: "pool3", mfa: {Contractor.SampleWorker, :start_link, []}, size: 3]
                  ]
    Logger.info("Starting Contractor")
    start_contractor(pools_config)
  end

  def start_contractor(pools_config) do
    Contractor.Supervisor.start_link(pools_config)
  end

  def checkout do
    Contractor.Server.checkout_worker()
  end

  def checkin(worker_pid) do
    Contractor.Server.checkin_worker(worker_pid)
  end

  def status do
    Contractor.Server.get_status()
  end

end

