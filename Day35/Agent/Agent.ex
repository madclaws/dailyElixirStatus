defmodule UserMonitor do
  @moduledoc """
    Monitors the activity of User.
    Donr with Agents #OTP
  """
  use Agent

  def start_monitor({channel_name, userid})  do
    Agent.start_link(fn -> %{"status" => "pong", "channelname" => channel_name, "userid" => userid} end)
  end

  def get_user_status(monitor_id) do
    Agent.get(monitor_id, &Map.get(&1, "status"))
  end

  def update_user_status(monitor_id, status) do
    Agent.update(monitor_id, &Map.put(&1, "status", status))
  end

  def get_user_info(monitor_id) do
    Agent.get(monitor_id, &Map.values(&1))
  end

end
