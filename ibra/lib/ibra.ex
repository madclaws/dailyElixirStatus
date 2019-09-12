defmodule Ibra do
  @moduledoc """
  Documentation for Ibra.
  """
  use Application
  require Logger
  def start(type, _args) do
    children = [
      {Ibra.Server, [[]]}
    ]
    case type do
      :normal ->
        Logger.info("Application started normally on #{node()}")
      {:takeover, old_node} ->
        Logger.info("#{node()} is taking over #{old_node}")
      {:failureover, old_node} ->
        Logger.info("#{old_node} is failing over to #{node()}")
    end
    Supervisor.start_link(children, [strategy: :one_for_one, name: {:global, Ibra.Supervisor}])
  end

  def fact() do
    Ibra.Server.fact()
  end
end
