defmodule GameStateTest do
  use ExUnit.Case
  alias TicTacToe.Core.GameState

  @gamestate_test %{
    match_id: nil,
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
    players: %{}
  }

  # @tag :skip
  test "create_match" do
    {:ok, pid} = GameState.create_match("jojo")
    assert is_pid(pid)
  end

  # @tag :skip
  test "joining match" do
    {:ok, pid} = GameState.create_match("jojo")
    GameState.join(pid, "anandu")
    GameState.join(pid, "dibyanshu")

    assert GameState.start_game(pid) ===
             %TicTacToe.Core.GameState{
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
               players: %{"anandu" => "x", "dibyanshu" => "o"},
               possible_grids: [0, 1, 2, 3, 4, 5, 6, 7, 8],
             }
  end

  # @tag :skip
  test "invalid_move, wrong turn" do
    {:ok, pid} = GameState.create_match("jojo")
    GameState.join(pid, "anandu")
    GameState.join(pid, "dibyanshu")
    assert GameState.move(pid, "dibyanshu", 1)
    === {"invalid", "Not your turn"}
  end

  #  @tag :skip
   test "invalid_move, wrong grid input" do
    {:ok, pid} = GameState.create_match("jojo")
    GameState.join(pid, "anandu")
    GameState.join(pid, "dibyanshu")
    assert GameState.move(pid, "anandu", -1)
    === {"invalid", "Invalid grid input"}
  end

  # @tag :skip
  test "valid  move, putting x" do
   {:ok, pid} = GameState.create_match("jojo")
   GameState.join(pid, "anandu")
   GameState.join(pid, "dibyanshu")
   assert GameState.move(pid, "anandu", 5)
   === {"valid", {false, nil},
   %TicTacToe.Core.GameState{
    match_id: "jojo",
    gridstate: %{
      0 => nil,
      1 => nil,
      2 => nil,
      3 => nil,
      4 => nil,
      5 => "x",
      6 => nil,
      7 => nil,
      8 => nil
    },
    current_turn: 1,
    players: %{"anandu" => "x", "dibyanshu" => "o"},
    possible_grids: [0, 1, 2, 3, 4, 6, 7, 8],
  }}
 end

#  @tag :skip
 test "valid  move, putting o" do
  {:ok, pid} = GameState.create_match("jojo")
  GameState.join(pid, "anandu")
  GameState.join(pid, "dibyanshu")
  GameState.move(pid, "anandu", 5)
  assert GameState.move(pid, "dibyanshu", 8)
  === {"valid",{false, nil},
  %TicTacToe.Core.GameState{
   match_id: "jojo",
   gridstate: %{
     0 => nil,
     1 => nil,
     2 => nil,
     3 => nil,
     4 => nil,
     5 => "x",
     6 => nil,
     7 => nil,
     8 => "o"
   },
   current_turn: 0,
   players: %{"anandu" => "x", "dibyanshu" => "o"},
   possible_grids: [0, 1, 2, 3, 4, 6, 7],
 }}

  end

#  @tag :skip
  test "invalid move, trying to put value in al filled grid" do
    {:ok, pid} = GameState.create_match("jojo")
    GameState.join(pid, "anandu")
    GameState.join(pid, "dibyanshu")
    GameState.move(pid, "anandu", 5)
    assert GameState.move(pid, "dibyanshu", 5)
    === {"invalid", "Invalid grid input"}
  end

  # @tag :skip
  test "valid move, but not yet gameover" do
    {:ok, pid} = GameState.create_match("jojo")
    GameState.join(pid, "anandu")
    GameState.join(pid, "dibyanshu")
    GameState.move(pid, "anandu", 5)
    assert GameState.move(pid, "dibyanshu", 8)
    === {"valid",{false, nil},
     %TicTacToe.Core.GameState{
     match_id: "jojo",
     gridstate: %{
       0 => nil,
       1 => nil,
       2 => nil,
       3 => nil,
       4 => nil,
       5 => "x",
       6 => nil,
       7 => nil,
       8 => "o"
     },
     current_turn: 0,
     players: %{"anandu" => "x", "dibyanshu" => "o"},
     possible_grids: [0, 1, 2, 3, 4, 6, 7],
   }}
  end

  #  @tag :skip
   test "valid move, gameover and there is a winner" do
    {:ok, pid} = GameState.create_match("jojo")
    GameState.join(pid, "anandu")
    GameState.join(pid, "dibyanshu")
    GameState.move(pid, "anandu", 4)
    GameState.move(pid, "dibyanshu", 7)
    GameState.move(pid, "anandu", 8)
    GameState.move(pid, "dibyanshu", 0)
    GameState.move(pid, "anandu", 5)
    GameState.move(pid, "dibyanshu", 2)
    GameState.move(pid, "anandu", 6)
    assert GameState.move(pid, "dibyanshu", 1)
    === {"valid",{true, "dibyanshu"},
     %TicTacToe.Core.GameState{
     match_id: "jojo",
     gridstate: %{
       0 => "o",
       1 => "o",
       2 => "o",
       3 => nil,
       4 => "x",
       5 => "x",
       6 => "x",
       7 => "o",
       8 => "x"
     },
     current_turn: 0,
     players: %{"anandu" => "x", "dibyanshu" => "o"},
     possible_grids: [3],
   }}
  end


  #  @tag :skip
  test "valid move, gameover and there but its a draw" do
    {:ok, pid} = GameState.create_match("jojo")
    GameState.join(pid, "anandu")
    GameState.join(pid, "dibyanshu")
    GameState.move(pid, "anandu", 4)
    GameState.move(pid, "dibyanshu", 8)
    GameState.move(pid, "anandu", 5)
    GameState.move(pid, "dibyanshu", 3)
    GameState.move(pid, "anandu", 6)
    GameState.move(pid, "dibyanshu", 2)
    GameState.move(pid, "anandu", 7)
    GameState.move(pid, "dibyanshu", 1)
    assert GameState.move(pid, "anandu", 0)
    === {"valid",{true, nil},
     %TicTacToe.Core.GameState{
     match_id: "jojo",
     gridstate: %{
       0 => "x",
       1 => "o",
       2 => "o",
       3 => "o",
       4 => "x",
       5 => "x",
       6 => "x",
       7 => "x",
       8 => "o"
     },
     current_turn: 1,
     players: %{"anandu" => "x", "dibyanshu" => "o"},
     possible_grids: [],
   }}
  end
end
