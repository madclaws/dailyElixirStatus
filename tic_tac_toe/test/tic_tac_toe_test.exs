defmodule TicTacToeTest do
  use ExUnit.Case
  doctest TicTacToe

  @tag :skip
  test "game simulation" do
    assert TicTacToe.start_simulation()
    === %TicTacToe.Core.GameState{
      match_id: "jojo",
      gridstate: %{
        0 => nil,
        1 => nil,
        2 => nil,
        3 => nil,
        4 => nil,
        5 => nil,
        6 => nil,
        7 => nil,
        8 => nil
      },
      current_turn: 0,
      possible_grids: [0, 1, 2, 3, 4, 5, 6, 7, 8],
      players: %{"anandu" => "x", "dibyanshu" => "o"}
    }
  end
end
