defmodule Kalavastha do
  @moduledoc """
    Manages Coordinator and Worker to work mutually and get the weather results.
  """
  alias Kalavastha.Worker
  alias Kalavastha.Coordinator
  def get_weather_info(location_list) do
    co_ordinator_pid = spawn(Coordinator, :loop, [[], Enum.count(location_list)])
    Enum.each(location_list, fn location -> spawn(Worker, :loop, []) |> send({co_ordinator_pid, location})  end)
  end

end
