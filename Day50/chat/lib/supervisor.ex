defmodule Chat.Supervisor do
  use Supervisor
  alias Chat.Server
  def start_link() do
    Supervisor.start_link(__MODULE__, [])
  end

  @impl true
  def init(_) do
    children = [
      {Server, []}
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
