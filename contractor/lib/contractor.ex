defmodule Contractor do
  use Application
  require Logger
  def start(_types, _args) do
    pool_config = [mfa: {Contractor.SampleWorker, :start_link, []}, size: 5]
    Logger.info("Starting Contractor")
    start_contractor(pool_config)
  end

  def start_contractor(pool_config) do
    Contractor.Supervisor.start_link(pool_config)
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

