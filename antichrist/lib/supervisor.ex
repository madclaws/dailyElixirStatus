defmodule Antichrist.Supervisor do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(_args) do
    children = [
      {Task.Supervisor, name: Antichrist.TasksSupervisor}
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
