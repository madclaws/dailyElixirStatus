defmodule Contractor.SampleWorker do
  use GenServer

  ##################
  # Client functions
  ##################
  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok)
  end

  def stop(pid) do
    GenServer.call(pid, :stop)
  end

  ##################
  # Server functions
  ##################

  @impl true
  def init(:ok) do
    {:ok, []}
  end

  @impl true
  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end

end
