defmodule TicTacToe do
  @moduledoc """
    Module that simulates the game
  """
  require Logger
  alias TicTacToe.Core.GameState

  def start_simulation() do
    Logger.info("Match id is jojo")
    {:ok, match_pid} = GameState.create_match("jojo")
    Logger.info("Match created with a match_processid #{inspect match_pid}")
    GameState.join(match_pid, "anandu") |> Logger.info
    GameState.join(match_pid, "dibyanshu") |> Logger.info
    GameState.start_game(match_pid)
    GameState.move(match_pid, "anandu", 4)
    GameState.move(match_pid, "dibyanshu", 8)
    GameState.move(match_pid, "anandu", 5)
    GameState.move(match_pid, "dibyanshu", 3)
    GameState.move(match_pid, "anandu", 6)
    GameState.move(match_pid, "dibyanshu", 2)
    GameState.move(match_pid, "anandu", 7)
    GameState.move(match_pid, "dibyanshu", 1)
    GameState.move(match_pid, "anandu", 0)
    # GameState.move(match_pid, "anandu", 1)
  end
end
