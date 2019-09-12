defmodule Ibra.Server do
  use GenServer

  # Client functions
  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: {:global, __MODULE__})
  end

  def fact() do
    GenServer.call({:global, __MODULE__}, :fact)
  end
  # Server functions
  @impl true
  def init(:ok) do
    state = File.read!("facts.txt")
    |> String.split("\n")
    {:ok, state}
  end

  @impl true
  def handle_call(:fact, _from, state) do
    fact = state
          |> Enum.shuffle()
          |> List.first()
          |> String.trim_trailing()
    {:reply, fact, state}
  end
end
