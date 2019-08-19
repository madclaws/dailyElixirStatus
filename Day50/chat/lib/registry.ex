defmodule Chat.Registry do
  use GenServer
  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def register_name() do

  end

  def unregister_name() do

  end

  def whereis_name do

  end
end
