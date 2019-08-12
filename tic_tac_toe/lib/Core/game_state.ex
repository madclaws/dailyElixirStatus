defmodule TicTacToe.Core.GameState do
  @moduledoc """
    Handles the Gameplay simulations, validation, Game state handling
  """
  require Logger
  use GenServer

  defstruct(
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
    # userid => "x", userid => "o"
    players: %{},
    possible_grids: [0, 1, 2, 3, 4, 5, 6, 7, 8]
  )

  ##################
  # Client functions
  ##################
  @doc """
    Creates a new match room (process) for given matchId

    Accepts matchId

    Returns {:ok, match_process_id}
  """
  def create_match(match_id) do
    GenServer.start_link(__MODULE__, match_id)
  end

  # Handles player joining match room
  # Accepts match_pid and userid
  # on join we check the length of map, if its empty, we will assign current_turn as
  # Entering the userid with corresponding "x"/"o" in ```players``` map
  def join(match_pid, userid) do
    GenServer.call(match_pid, {:join, userid})
  end

  def start_game(match_pid) do
    GenServer.call(match_pid, :start_game)
  end

  def move(match_pid, userid, grid) do
    GenServer.call(match_pid, {:move, userid, grid})
  end
  #################
  # Server functions
  #################



  @impl true
  def init(match_id) do
    {:ok, get_new_match_state(match_id)}
  end

  @impl true
  def handle_call({:join, userid}, _from, gamestate) do
    {:reply, "#{userid} joined", handle_join(userid, gamestate)}
  end

  @impl true
  def handle_call(:start_game, _from, gamestate) do
    Logger.info("Ok #{Map.keys(gamestate.players) |> get_current_player(gamestate.current_turn)}
    start your move ;)")
    {:reply, gamestate, gamestate}
  end

  @impl true
  def handle_call({:move, userid, grid}, _from, gamestate) do
    {response, gamestate} = case is_valid_move?(userid, grid, gamestate) do
                {false, reason} -> {{"invalid", reason}, gamestate}
                true            -> {result, updated_gamestate} = handle_valid_move(userid, grid, gamestate)
                  {{"valid", result, updated_gamestate}, updated_gamestate}
              end
    {:reply, response, gamestate}
  end

  ##################
  # Helper functions
  ##################

  defp get_new_match_state(match_id) do
    TicTacToe.Core.GameState.__struct__() |> assign_matchid(match_id)
  end

  defp assign_matchid(gamestate, match_id), do: put_in(gamestate.match_id, match_id)

  defp handle_join(userid, gamestate) do
    is_room_empty?(gamestate.players)
    |> add_player_to_game(userid, gamestate)
  end

  defp is_room_empty?(players_map) do
    Map.keys(players_map) |> length() === 0
  end

  defp add_player_to_game(true, userid, gamestate) do
    %{
      gamestate
      | current_turn: 0,
        players: get_updated_players_map(gamestate.players, userid, "x")
    }
  end

  defp add_player_to_game(false, userid, gamestate) do
    %{
      gamestate
      | players: get_updated_players_map(gamestate.players, userid, "o")
    }
  end

  defp get_updated_players_map(players_map, key, value), do: put_in(players_map[key], value)

  defp is_valid_move?(userid, grid, gamestate) do
    is_valid_turn?(userid, gamestate) |> is_valid_grid?(grid, gamestate)
  end

  defp is_valid_turn?(userid, gamestate), do: userid ===
    Map.keys(gamestate.players) |> get_current_player(gamestate.current_turn)

  defp is_valid_grid?(true, grid, gamestate) do
    case Enum.member?(gamestate.possible_grids, grid) do
      false -> {false, "Invalid grid input"}
      true -> true
    end
  end

  defp is_valid_grid?(false, _, _), do: {false, "Not your turn"}

  defp get_current_player(players_list, current_turn), do: Enum.at(players_list, current_turn)

  defp handle_valid_move(userid, grid, gamestate) do
    %{
      gamestate |
      gridstate: get_player_value(userid, gamestate)
                 |> get_updated_gridstate(grid, gamestate.gridstate),
      possible_grids: get_possible_grids(grid, gamestate.possible_grids),
      current_turn: get_next_turn(gamestate.current_turn)
    }
    |> is_gameover
  end

  defp get_updated_gridstate(player_value, grid, gridstate) do
    put_in(gridstate[grid], player_value)
  end

  defp get_player_value(userid, gamestate) do
    gamestate.players[userid]
  end

  defp get_possible_grids(grid, possible_grids) do
    Enum.filter(possible_grids, fn grid_item -> grid_item !== grid end)
  end

  defp get_next_turn(current_turn) do
    rem(current_turn + 1, 2)
  end

  defp is_gameover(gamestate) do
    case is_matching_gameover_pattern(gamestate, gamestate.gridstate) do
      {true, value} -> {{true, get_winner(value, gamestate)}, gamestate}
      false -> {{false, nil}, gamestate}
    end
  end

  defp is_matching_gameover_pattern(_gamestate, %{
    0 => x, 1 => x, 2 => x,
  }) when x !== nil, do: {true, x}

  defp is_matching_gameover_pattern(_gamestate, %{
    3 => x, 4 => x, 5 => x,
  }) when x !== nil, do: {true, x}

  defp is_matching_gameover_pattern(_gamestate, %{
    6 => x, 7 => x, 8 => x
  }) when x !== nil, do: {true, x}

  defp is_matching_gameover_pattern(_gamestate, %{
    0 => x,
    3 => x,
    6 => x,
  }) when x !== nil, do: {true, x}

  defp is_matching_gameover_pattern(_gamestate, %{
    1 => x,
    4 => x,
    7 => x,
  }) when x !== nil, do: {true, x}

  defp is_matching_gameover_pattern(_gamestate, %{
    2 => x,
    5 => x,
    8 => x
  }) when x !== nil, do: {true, x}

  defp is_matching_gameover_pattern(_gamestate, %{
    2 => x,
    4 => x,
    6 => x
  }) when x !== nil, do: {true, x}

  defp is_matching_gameover_pattern(_gamestate, %{
    0 => x,
    4 => x,
    8 => x
  }) when x !== nil, do: {true, x}

  defp is_matching_gameover_pattern(gamestate, _) do
    case length(gamestate.possible_grids) === 0 do
      true -> {true, nil}
      false -> false
    end
  end

  defp get_winner(nil, _), do: nil
  defp get_winner(winner_value, gamestate) do
    {userid, _winner_value} = Enum.find(gamestate.players, fn {_key, value} ->
                              value === winner_value
                            end)
    userid
  end

end
