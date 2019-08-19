defmodule Chat.Server do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: :chat_room)
  end

  def add_message(message) do
    GenServer.cast(:chat_room, {:add_message, message})
  end

  def get_message() do
    GenServer.call(:chat_room, :get_message)
  end

  @impl true
  def init(init_state) do
    {:ok, init_state}
  end

  @impl true
  def handle_cast({:add_message, message}, state) do
    {:noreply, [message | state]}
  end

  @impl true
  def handle_call(:get_message, _from, state) do
    {:reply, state, state}
  end

end
