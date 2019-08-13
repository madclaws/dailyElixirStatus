defmodule Cache.Core.Memory do
  @moduledoc """
    Handles the state of cache
  """
  use GenServer
  ##################
  # Client functions
  ##################

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, [name: __MODULE__])
  end

  def write({key, value}) do
    GenServer.cast(__MODULE__, {:write, {key, value}})
  end

  def read(key) do
    GenServer.call(__MODULE__, {:read, key})
  end

  def delete(key) do
    GenServer.cast(__MODULE__, {:delete, key})
  end

  def clear() do
    GenServer.cast(__MODULE__, :clear)
  end

  def exist(key) do
    GenServer.call(__MODULE__, {:exist, key})
  end

  ##################
  # Server functions
  ##################

  @impl true
  def init(init_state) do
    {:ok, init_state}
  end

  @impl true
  def handle_call({:read, key}, _from, memory_state) do
    {:reply, Map.get(memory_state, key), memory_state}
  end

  @impl true
  def handle_call({:exist, key}, _from, memory_state) do
    {:reply, Map.has_key?(memory_state, key), memory_state}
  end

  @impl true
  def handle_cast({:write, {key, value}}, memory_state) do
    memory_state = put_in(memory_state[key], value)
    {:noreply, memory_state}
  end

  @impl true
  def handle_cast({:delete, key}, memory_state) do
    {_, memory_state} = pop_in(memory_state[key])
    {:noreply, memory_state}
  end

  @impl true
  def handle_cast(:clear, _memory_state) do
    {:noreply, %{}}
  end

end
