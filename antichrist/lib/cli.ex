defmodule Antichrist.Cli do
  require Logger
  def main(args) do
    Application.get_env(:antichrist, :master_node)
    |> Node.start()
    Application.get_env(:antichrist, :slave_nodes)
    |> Enum.each(
      &Node.connect(&1))
    args
    |> parse_options
    |> process_options([node() | Node.list()])
  end

  defp parse_options(args) do
    OptionParser.parse(args, aliases: [n: :requests], strict: [requests: :integer])
  end

  defp process_options(options, nodes) do
    case options do
      {[requests: n], [url], []} ->
        do_requests(n, url, nodes)
      _ ->
        do_help()
      end
  end

  defp do_help() do
    IO.puts """
    Usage:
    blitzy -n [requests] [url]
    Options:
    -n, [--requests] # Number of requests
    Example:
    ./blitzy -n 100 http://www.foyohe.com
    """
    System.halt()
  end

  defp do_requests(n, url, nodes) do
    Logger.info("#{inspect(n)} ### #{inspect(url)} ### #{inspect(nodes)}")
    total_nodes = Enum.count(nodes)
        workers_on_each_node = div(n , total_nodes)
        nodes
        |> Enum.flat_map(fn node ->
            1..workers_on_each_node
            |> Enum.map(fn _->
                Task.Supervisor.async({Antichrist.TasksSupervisor, node}, Antichrist.Worker, :start, [url])
            end)
        end)
        |> Enum.map(&Task.await(&1, :infinity))
        |> Antichrist.parse_results()
  end
end
